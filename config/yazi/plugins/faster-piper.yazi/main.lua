--- @since 26.8.15
local M = {}

-- If Yazi asks for a skip larger than this, jump straight to the last page.
local SKIP_JUMP_THRESHOLD = 999
local PEEK_JUMP_THRESHOLD = 99999999
-- Maximum time allowed for preview (in ms)
local TIME_OUT_LOCK = 5000
local TIME_OUT_PREVIEW = 200
-- Maximum time for stale-lock directories
local LOCK_TTL_SEC = 60

----------------------------------------------------------------------
-- Cache header layout (1-based line numbers)
--
-- We keep ALL header-related offsets centralized here.
-- When adding a new header field:
--   1) insert it into this layout
--   2) bump HEADER.N
--   3) bump HEADER.VERSION so existing caches are discarded
--   4) update any reader functions that fetch header fields
----------------------------------------------------------------------

local HEADER = {
  -- Layout marker, always stored on the FIRST line.
  --
  -- Bump this on ANY change to the layout below. A cache written by an
  -- older version then fails validation, is removed, and is regenerated.
  -- This is what makes header changes safe; there is no migration path.
  --
  -- It is NOT the plugin version, and must not follow it. A release that
  -- leaves this layout untouched keeps the same marker, so caches stay
  -- valid across upgrades. Bumping it needlessly discards every user's
  -- cached preview for nothing.
  VERSION = "FPCACHE1",

  -- Total number of header lines stored at the top of the cache file.
  N = 6,

  -- Which header line contains what (1-based):
  LINE_VER   = 1, -- layout marker, must equal HEADER.VERSION
  LINE_CMD   = 2, -- raw user-provided command template (job.args[1], unchanged)
  LINE_NLINE = 3, -- number of *content* lines (excludes headers)
  LINE_W     = 4, -- preview width used to generate this cache
  LINE_H     = 5, -- preview height used to generate this cache
  LINE_T     = 6, -- terminal theme used to generate this cache ("dark"|"light")
}

-- Content starts immediately after the header.
local function content_first_line()
  return HEADER.N + 1
end

----------------------------------------------------------------------
-- Utils
----------------------------------------------------------------------

--- Parse a "truthy/falsey" value into a boolean, with an explicit default.
---
--- This is meant for plugin args / config values that might arrive as:
---   - nil           -> returns `default`
---   - boolean       -> returns that boolean
---   - number        -> 0 = false, non-zero = true
---   - string        -> common on/off values (case-insensitive):
---                      true:  "true", "1", "yes", "on"
---                      false: "false", "0", "no",  "off"
---                      anything else -> returns `default`
---   - other types   -> returns `default`
---
--- param v any            ->  Value to parse.
--- param default boolean  ->  The fallback value used when `v` is nil/unknown.
--- return boolean
local function is_true(v, default)
  assert(type(default) == "boolean", "is_true: default must be a boolean")

  if v == nil then
    return default
  end
  if v == true then
    return true
  end
  if v == false then
    return false
  end
  if type(v) == "number" then
    return v ~= 0
  end
  if type(v) == "string" then
    v = v:lower()
    if v == "true" or v == "1" or v == "yes" or v == "on" then
      return true
    end
    if v == "false" or v == "0" or v == "no" or v == "off" then
      return false
    end
    -- Unknown string: fall back to default (or you can choose to return true)
    return default
  end

  -- Unknown type: fall back to default
  return default
end

----------------------------------------------------------------------
-- fs_path(url) -> string
--
-- Convert Yazi Url into a real filesystem path string for external tools.
--
-- Why:
--   In some views (notably search results), Yazi uses virtual URLs such as:
--     search://dupli:1:1//Users/andrea/file.txt
--   External commands (bat, glow, tar, etc.) expect a plain filesystem path.
--
-- How:
--   Yazi already exposes the underlying path via `url.path`, and also tells
--   us whether this Url comes from search using `url.spec.is_search`.
--
-- Behavior:
--   - For search URLs: return tostring(url.path)
--   - For regular file URLs: return tostring(url)
--   - Defensive fallback: if url.path is missing/empty, fall back to tostring(url)
----------------------------------------------------------------------
local function fs_path(url)
  if url and url.spec.is_search then
    local p = url.path
    if p then
      local s = tostring(p)
      if s ~= "" then
        return s
      end
    end
  end
  return tostring(url)
end

-- Split text into "lines" (like read_line()).
-- Drops empty / whitespace-only lines to avoid blank entries.
local function split_lines(s)
  local t = {}
  if not s or s == "" then
    return t
  end

  -- Ensure the last line is captured even if s doesn't end with '\n'
  s = s .. "\n"

  for line in s:gmatch("(.-)\n") do
    -- Remove empty and whitespace-only lines:
    -- - empty: line == ""
    -- - whitespace-only: line:match("^%s*$")
    if not line:match("^%s*$") then
      t[#t + 1] = line .. "\n"
    end
  end

  return t
end

----------------------------------------------------------------------
-- read_line_range(path, first, last) -> lines, err
--
-- Return lines [first, last] (1-based, inclusive) of a text file as a
-- table of strings, each WITHOUT its trailing newline. A trailing \r is
-- dropped too, so a cache written through a Windows shell parses exactly
-- like one written under Unix.
--
-- This replaces `sed -n '<first>,<last>p'`. Yazi also runs on Windows,
-- where `sed` is absent from the default PATH even when a POSIX shell is
-- installed (Git for Windows keeps it in usr\bin, off PATH). For the few
-- lines we need, spawning a process per peek costs more than reading the
-- file here anyway.
----------------------------------------------------------------------
local function read_line_range(path, first, last)
  local fh, err = io.open(path, "r")
  if not fh then
    return nil, tostring(err)
  end

  local out, i = {}, 0
  for line in fh:lines() do
    i = i + 1
    if i >= first then
      out[#out + 1] = (line:gsub("\r$", ""))
    end
    if i >= last then
      break
    end
  end
  fh:close()

  return out, nil
end

function M.format(job, lines)
  local format = job.args.format
  if format ~= "url" then
    local s = table.concat(lines, ""):gsub("\r", ""):gsub("\t", string.rep(" ", rt.preview.tab_size))
    return ui.Text.parse(s):area(job.area)
  end

  for i = 1, #lines do
    lines[i] = lines[i]:gsub("[\r\n]+$", "")

    local icon = th.icon:match(File {
      url = Url(lines[i]),
      cha = Cha { mode = tonumber(lines[i]:sub(-1) == "/" and "40700" or "100644", 8) },
    })

    if icon then
      lines[i] = ui.Line { ui.Span(" " .. icon.text .. " "):style(icon.style), lines[i] }
    end
  end
  return ui.Text(lines):area(job.area)
end

local read_cache_header  -- forward declaration

----------------------------------------------------------------------
-- Terminal theme, as exposed to preview commands via $t.
--
-- rt.term.light() returns nil when the terminal does not report a
-- colour scheme. We treat that as "dark", which matches Yazi's own
-- default appearance. The fallback is deliberate and documented in the
-- README, because a user on an unreporting light terminal has no other
-- way to explain the result.
----------------------------------------------------------------------
local function current_theme()
  return rt.term.light() and "light" or "dark"
end

----------------------------------------------------------------------
-- Does `tpl` read the environment variable `name`?
--
-- Matches "$name" and "${name}". The frontier pattern stops "$t" from
-- matching inside "$theme".
--
-- Over-matching is harmless: "$t" inside single quotes, or escaped as
-- "\$t", costs one extra cache rebuild. Under-matching would leave a
-- stale cache, so the check errs toward rebuilding.
----------------------------------------------------------------------
local function uses_env(tpl, name)
  if tpl:find("${" .. name .. "}", 1, true) then
    return true
  end
  return tpl:find("%$" .. name .. "%f[^%w_]") ~= nil
end

-- Header-based freshness check:
-- - cache mtime >= source mtime
-- - header parses and carries the current layout version
-- - header recipe matches the requested one, IF Yazi passed one
-- - header w/h/theme match the current ones, EACH only if the recipe
--   reads the matching variable ($w, $h, $t)
-- Returns:
--   ok, hdr
-- where hdr is the parsed header if available.
local function cache_is_fresh(job, cache_path)
  local c = fs.cha(cache_path)
  local s = job.file.cha
  if not (c and c.mtime and s and s.mtime and c.mtime >= s.mtime) then
    return false, nil
  end

  local hdr = read_cache_header(cache_path)
  if not hdr then
    return false, nil
  end

  -- The recipe is part of the cache identity: output produced by a
  -- different command is not a cache hit.
  --
  -- Yazi omits the previewer arguments on some calls, e.g. seek. We
  -- cannot compare then, and generate_cache recovers the stored recipe.
  local tpl = job.args and job.args[1]
  if tpl and tpl ~= "" and tpl ~= hdr.cmd then
    return false, nil
  end

  -- Below, only the variables the recipe actually reads can affect its
  -- output, so only those invalidate the cache. A recipe that ignores
  -- $w produces identical bytes at any width; discarding its cache on
  -- every resize would be pure waste.
  --
  -- This assumes the command learns the geometry and the theme from us,
  -- not by inspecting the terminal itself. That holds here, because
  -- stdout is redirected to the cache file and stdin is closed, so a
  -- command sees a pipe rather than a terminal.
  --
  -- Caveat: a command that detects the theme through its own channel
  -- (e.g. `bat --theme=auto:always`) defeats the $t test, and its cache
  -- will not refresh. See the README.
  if uses_env(hdr.cmd, "w") and hdr.w ~= job.area.w then
    return false, nil
  end
  if uses_env(hdr.cmd, "h") and hdr.h ~= job.area.h then
    return false, nil
  end
  if uses_env(hdr.cmd, "t") and hdr.t ~= current_theme() then
    return false, nil
  end

  return true, hdr
end

-- Derive cache path from file_cache base + current w/h
local function get_cache_path(job)
  local base = ya.file_cache({ file = job.file, skip = 0 })
  if not base then
    return nil, "caching-disabled-by-yazi"
  end
  return Url(tostring(base)), nil
end

-- Identify this Yazi instance. Used to keep the lock and the scratch
-- files of two instances previewing the same file apart.
local function instance_id()
  local app_id = ya.id and ya.id("app") or nil
  if app_id and app_id.value then
    return tostring(app_id.value)
  end
  return "noid"
end

local function lock_path_for(cache_path)
  -- faster-piper lock system
  return Url(string.format("%s_FP_%s.lock", tostring(cache_path), instance_id()))
end

----------------------------------------------------------------------
-- Scratch files used while generating one cache entry.
--
-- They are named per instance and per cache entry, so two generators
-- racing for the same preview (different instances, or a lock that was
-- broken as stale) never write the same scratch path. The finished file
-- appears at cache_path through a single rename, so a reader sees either
-- the previous cache or the new one, never a half-written mixture.
----------------------------------------------------------------------
local function scratch_paths_for(cache_path)
  local base = string.format("%s_FP_%s", tostring(cache_path), instance_id())
  return Url(base .. ".out"), Url(base .. ".hdr")
end

local function lock_is_held(cache_path)
  local lock = lock_path_for(cache_path)
  return fs.cha(lock) ~= nil
end

-- Wait until cache is safe to read: unlocked + fresh.
-- Returns: ok, hdr
local function wait_for_ready_cache(job, cache_path, timeout_ms)
  local deadline = ya.time() + (timeout_ms / 1000)
  while ya.time() < deadline do
    -- If writer is active, don't even try to read.
    if lock_is_held(cache_path) then
      ya.sleep(0.02) -- 20ms when locked
    else
      if not fs.cha(cache_path) then
        ya.sleep(0.01)
      else
        local ok, hdr = cache_is_fresh(job, cache_path)
        if ok then return true, hdr end
        ya.sleep(0.01)
      end
    end
  end
  return false, nil
end

local function lock_age_seconds(lock_path)
  local c = fs.cha(lock_path)
  if not (c and c.mtime) then
    return math.huge
  end
  return ya.time() - c.mtime
end

local function break_lock_dir(lock_path)
  -- best-effort; ignore failures
  fs.remove("dir_all", lock_path)
end

-- Try to acquire lock by creating a directory (atomic on POSIX filesystems).
-- Returns true if acquired, false if timed out.
local function acquire_lock(lock_path, timeout_ms)
  timeout_ms = timeout_ms or 500
  local deadline = ya.time() + (timeout_ms / 1000)

  while ya.time() < deadline do
    local ok = fs.create("dir", lock_path)
    if ok then
      return true
    end

    -- If it exists and is stale, break it and retry immediately
    if lock_age_seconds(lock_path) > LOCK_TTL_SEC then
      -- ya.dbg({ stale_lock = tostring(lock_path), age = lock_age_seconds(lock_path) })
      break_lock_dir(lock_path)
    else
      ya.sleep(0.01)
    end
  end

  return false
end

----------------------------------------------------------------------
-- Release a held lock, synchronously.
--
-- This deliberately avoids fs.remove(): that is an async Yazi API, and
-- the release must also work from a to-be-closed handler, where the
-- coroutine can no longer yield ("attempt to yield across a C-call
-- boundary"). os.remove() is plain C and removes an empty directory on
-- POSIX. On Windows it refuses directories, so an abandoned lock there
-- still has to wait for LOCK_TTL_SEC; nothing else breaks.
----------------------------------------------------------------------
local function release_lock(lock_path)
  os.remove(tostring(lock_path))
end

----------------------------------------------------------------------
-- Read and validate a full header in ONE call.
-- Returns:
--   hdr = { cmd = <string>, nline = <number>, w = <number> }  on success
--   nil, err                                                  on failure
--
-- Notes:
-- - cmd is returned without trailing newline.
-- - nline and w are parsed as integers.
----------------------------------------------------------------------
read_cache_header = function(cache_path)
  -- Read the first HEADER.N lines at once
  local lines, err = read_line_range(tostring(cache_path), 1, HEADER.N)
  if not lines then
    return nil, err
  end

  if #lines < HEADER.N then
    return nil, "incomplete cache header (need " .. HEADER.N .. " lines, got " .. #lines .. ")"
  end

  -- Check the layout marker BEFORE anything else. A cache written by an
  -- older version has a different layout, so every offset below is wrong
  -- for it. Rejecting here makes the caller discard and regenerate it.
  if lines[HEADER.LINE_VER] ~= HEADER.VERSION then
    return nil, "cache header layout is outdated; expected " .. HEADER.VERSION
  end

  local cmd = lines[HEADER.LINE_CMD]
  local nline = tonumber((lines[HEADER.LINE_NLINE] or ""):match("^%s*(%d+)%s*$"))
  local w = tonumber((lines[HEADER.LINE_W] or ""):match("^%s*(%d+)%s*$"))
  local h = tonumber((lines[HEADER.LINE_H] or ""):match("^%s*(%d+)%s*$"))
  local t = (lines[HEADER.LINE_T] or ""):match("^%s*(%a+)%s*$")

  if cmd == nil then
    return nil, "missing cmd header line"
  end
  if not nline then
    return nil, "invalid line-count header: " .. tostring(lines[HEADER.LINE_NLINE])
  end
  if not w then
    return nil, "invalid width header: " .. tostring(lines[HEADER.LINE_W])
  end
  if not h then
    return nil, "invalid height header: " .. tostring(lines[HEADER.LINE_H])
  end
  if t ~= "dark" and t ~= "light" then
    return nil, "invalid theme header: " .. tostring(lines[HEADER.LINE_T])
  end

  return { cmd = cmd, nline = nline, w = w, h = h, t = t }, nil
end


----------------------------------------------------------------------
-- Cache generation
--
-- Behavior:
-- - If job.args[1] is present: use it as recipe.
-- - Else: if cache exists and has valid header: reuse cached recipe (LINE_CMD).
-- - Else: fail (no recipe available).
--
-- Always writes a HEADER.N-line header:
--   1) layout marker (HEADER.VERSION)
--   2) command template (exact string we use)
--   3) number of content lines (wc -l, trimmed)
--   4) width used (w, trimmed)
--   5) height used (h, trimmed)
--   6) terminal theme used (t)
----------------------------------------------------------------------
local function generate_cache(job, cache_path)
  local source_path = fs_path(job.file.url)

  -- 1) Decide template: job.args[1] or cached header
  local tpl = job.args and job.args[1]
  if tpl == "" then tpl = nil end

  if not tpl then
    local cha = fs.cha(cache_path)
    if cha then
      local hdr, herr = read_cache_header(cache_path)
      if hdr and hdr.cmd and hdr.cmd ~= "" then
        tpl = hdr.cmd
      else
        -- header invalid -> cannot recover recipe
        ya.err("faster-piper: cache header invalid; cannot reuse recipe: " .. tostring(herr))
      end
    end
  end

  if not tpl or tpl == "" then
    ya.err("faster-piper: missing generator command template (job.args[1]) and no usable cached header")
    return false
  end

  -- Guard: template must be single-line for env passing + header layout
  if tpl:find("\n", 1, true) then
    ya.err("faster-piper: command template contains newline; unsupported")
    return false
  end

  -- 2) Expand "$1" safely for external tools
  --
  -- ya.quote() escapes for the *host* shell by default, which on Windows is
  -- cmd: it would turn `%` into `%%cd:~,` and quote with `"`. Everything here
  -- is fed to `sh`, so we force POSIX escaping with the second argument.
  --
  -- The `%` in the replacement string is doubled because gsub reads `%1`,
  -- `%0`, ... as capture references; a path containing `%` would otherwise
  -- raise "invalid use of '%' in replacement string".
  local quoted_source = ya.quote(source_path, true):gsub("%%", "%%%%")
  local final = tpl:gsub('"$1"', quoted_source)

  local out_url, hdr_url = scratch_paths_for(cache_path)
  local out_path = ya.quote(tostring(out_url), true)
  local hdr_path = ya.quote(tostring(hdr_url), true)
  local quoted_path = ya.quote(tostring(cache_path), true)

  -- 3) Generate content into a scratch file, prepend the header into a
  --    second one, then rename that over cache_path.
  --
  --    cache_path itself is never written in place: a generator that is
  --    killed halfway (Yazi cancels superseded peeks) would otherwise
  --    leave a headerless stump where a perfectly good cache used to be.
  --
  -- - We trim whitespace from wc output to avoid leading spaces.
  -- - We also trim $w and $h to be safe.
  local cmd = string.format([[
    (%s) > %s &&
    L=$(wc -l < %s | tr -d '[:space:]') &&
    W=$(printf '%%s' "$w" | tr -d '[:space:]') &&
    H=$(printf '%%s' "$h" | tr -d '[:space:]') &&
    { printf '%%s\n' "$FP_VER"; printf '%%s\n' "$FP_TPL"; printf '%%s\n' "$L"; printf '%%s\n' "$W"; printf '%%s\n' "$H"; printf '%%s\n' "$t"; cat %s; } > %s &&
    mv %s %s
  ]],
    final,
    out_path,
    out_path,
    out_path,
    hdr_path,
    hdr_path,
    quoted_path
  )

  local function discard_scratch()
    fs.remove("file", out_url)
    fs.remove("file", hdr_url)
  end

  local child, err = Command("sh")
    :arg({ "-c", cmd })
    :env("w", tostring(job.area.w))
    :env("h", tostring(job.area.h))
    :env("t", current_theme())
    :env("FP_TPL", tpl) -- EXACT template string we used
    :env("FP_VER", HEADER.VERSION) -- header layout marker
    -- Windows: a Cygwin-derived `sh` (Git Bash, MSYS2) upper-cases the
    -- environment it inherits from a native process, which would turn our
    -- $w/$h/$t into $W/$H/$T and leave the recipe reading empty values.
    -- Harmless everywhere else. piper.yazi does the same.
    :env("CYGWIN", "noupcaseenv")
    :stdin(Command.NULL)
    :stdout(Command.NULL)
    :stderr(Command.PIPED)
    :spawn()

  if not child then
    ya.err("faster-piper: failed to spawn: " .. tostring(err))
    discard_scratch()
    return false
  end

  local output, werr = child:wait_with_output()
  if not output then
    ya.err("faster-piper: wait failed: " .. tostring(werr))
    discard_scratch()
    return false
  end

  if not output.status.success then
    ya.err("faster-piper: command failed (code=" .. tostring(output.status.code) .. "): " .. tostring(output.stderr))
    discard_scratch()
    return false
  end

  -- The content scratch file has served its purpose; the header one was
  -- renamed away by the shell.
  fs.remove("file", out_url)

  -- 4) Sanity-check the newly written header
  local hdr, herr = read_cache_header(cache_path)
  if not hdr then
    ya.err("faster-piper: wrote cache but header sanity-check failed: " .. tostring(herr))
    fs.remove("file", cache_path)
    return false
  end
  return true
end

-- -------------------------------------------------------------------
-- Ensure cache exists & is fresh; regenerate if needed
-- -------------------------------------------------------------------
local function ensure_cache(job)
  local cache_path, why = get_cache_path(job)
  if not cache_path then
    return nil, why
  end

  -- Fresh -> done
  if cache_is_fresh(job, cache_path) then
    return cache_path
  end

  -- Acquire lock. It only deduplicates work: a generator that fails to
  -- get it still produces a correct cache, because every generator
  -- writes its own scratch files and publishes them with one rename.
  local lock_path = lock_path_for(cache_path)
  local locked = acquire_lock(lock_path, TIME_OUT_LOCK)

  -- Hand the lock back on every exit path, including the one Yazi takes
  -- when it abandons this peek.
  --
  -- Yazi drops the coroutine of a superseded peek at whatever await point
  -- it has reached, so anything written after generate_cache() simply
  -- never runs. A to-be-closed variable is closed even then, and is the
  -- only hook we get. Without it a single abandoned peek wedges every
  -- later peek of that file until LOCK_TTL_SEC expires; Yazi peeks twice
  -- in quick succession on startup, which is enough to hit this on a
  -- generator as cheap as `eza --tree`.
  local _lock <close> = setmetatable({}, {
    __close = function()
      if locked then
        release_lock(lock_path)
      end
    end,
  })

  -- Re-check: whoever held the lock may have generated it meanwhile.
  -- This also covers the timed-out case, where we go on to generate
  -- without the lock rather than reporting failure.
  if cache_is_fresh(job, cache_path) then
    return cache_path
  end

  if not generate_cache(job, cache_path) then
    return nil, "generate-failed"
  end

  return cache_path
end


----------------------------------------------------------------------
-- Yazi hooks
----------------------------------------------------------------------

function M:preload(job)
  -- Preload is explicitly configured -> always warm cache
  local cache_path = ensure_cache(job)
  return cache_path ~= nil
end

----------------------------------------------------------------------
-- NOTE ABOUT "JUMP TO END" / HUGE SCROLLS (Yazi limitation + workaround)
--
-- Problem:
--   Yazi's preview scrolling model is built around a `skip` integer that
--   is passed into `peek(job)` and represents "how many units to skip"
--   (lines for text previewers). Yazi does NOT provide:
--
--     1) The total number of lines of the previewed content.
--     2) Any callback where `seek()` can read user args (command, caching).
--     3) A reliable shared Lua state between `seek()` and `peek()`.
--
--   In particular:
--     - `seek(job)` is stateless and arg-agnostic. It cannot know whether
--       caching is enabled, which generator is used, or what cache file exists.
--     - We cannot maintain a Lua table indexed by filename to store per-file
--       metadata (like total lines), because Yazi may reload the Lua state
--       between calls. So `seek()` cannot rely on anything computed earlier
--       by `peek()` or `preload()`.
--
-- Consequence:
--   When the user performs a large scroll action (e.g. PageDown held, or
--   "scroll to bottom"), Yazi may ask us to render extremely large skip
--   values. But we cannot clamp skip in `seek()` (we don't know file length),
--   and Yazi itself may sanitize/clamp very large skips in inconsistent ways.
--
-- The only place where we CAN know the "file length" is inside `peek()`:
--   because we embed the total line count in the cache file itself as the
--   first line header.
--
-- But there is a catch:
--   We MUST NOT silently change the rendering range inside `peek()`, because
--   Yazi tracks preview state using the requested skip. If we locally clamp
--   skip without telling Yazi, Yazi believes we are at one skip while we are
--   actually rendering a different one, and scrolling becomes desynchronized.
--
-- Workaround:
--   We implement "jump to end" as a two-step protocol:
--
--     (A) seek() detects a "huge scroll in one action" using ONLY job.units,
--         and emits a special sentinel skip value:
--
--           skip = cur + PEEK_JUMP_THRESHOLD + 1
--
--         The "+1" ensures skip > PEEK_JUMP_THRESHOLD even when cur == 0.
--
--     (B) peek() sees skip > PEEK_JUMP_THRESHOLD, reads `total` from the
--         cache header, and if (total <= PEEK_JUMP_THRESHOLD) then we know
--         this skip is "definitely beyond EOF", so we clamp by EMITTING a
--         NEW peek() call with skip=max_skip (last page), then return:
--
--           ya.emit("peek", { max_skip, only_if = job.file.url })
--           return
--
--         This keeps Yazi's internal state consistent because it re-runs peek
--         with the corrected skip.
--
--     (C) For very large files (total > PEEK_JUMP_THRESHOLD) we cannot jump
--         reliably without knowing the actual length ahead of time. In that
--         case we simply treat the skip as a real skip and do nothing special.
--         This is the best we can do under Yazi's constraints.
--
-- Summary:
--   - seek() cannot know file length -> cannot clamp skip.
--   - peek() CAN know file length via cache header.
--   - peek() MUST NOT locally clamp -> must re-emit peek() with corrected skip.
--   - sentinel skips are used to request "jump-to-end" in a stateless way.
--
-- Do NOT remove this logic unless Yazi gains:
--   - a reliable shared Lua state between calls, OR
--   - total line count passed into preview jobs, OR
--   - a preview API that supports clamping without desync.
----------------------------------------------------------------------

function M:seek(job)
  -- SEEK MUST BE STATELESS AND ARG-AGNOSTIC
  -- Yazi does not provide information in job whether the cache is present
  -- and what command generated the preview content
  local cur = cx.active.preview.skip or 0
  local units = job.units or 0

  -- Candidate skip (absolute)
  local new_skip = cur + units

  -- Fast path: if user scrolls *way* up in one action, jump to top.
  if units < -SKIP_JUMP_THRESHOLD then
    new_skip = 0
  end

  if units > SKIP_JUMP_THRESHOLD then
    ya.emit("peek", { cur + PEEK_JUMP_THRESHOLD + 1, only_if = job.file.url })
    return
  end

  new_skip = math.max(0, new_skip)
  ya.emit("peek", { new_skip, only_if = job.file.url })
end

function M:peek(job)
  local cache_path, why
  local hdr, herr

  if is_true(job.args.rely_on_preloader,false) then
    cache_path, why = get_cache_path(job)
    if not cache_path then
      ya.preview_widget(job, ui.Text.parse("faster-piper: " .. tostring(why)):area(job.area))
      return
    end

    local ok
    ok, hdr = cache_is_fresh(job, cache_path)   -- hdr is assured to be nil when ok==false

    if not ok then
      -- If the cache file exists, we can self-heal (resize case) by reusing cmd from header.
      if fs.cha(cache_path) then
        local ensured, ewhy = ensure_cache(job)
        if ensured then
          cache_path = ensured
        else
          ya.preview_widget(job,
            ui.Text.parse("faster-piper: failed to refresh cache: " .. tostring(ewhy)):area(job.area)
          )
          return
        end
      else
        -- Cache file doesn't exist (save-race): wait briefly for preloader to write it.
        local ok2
        ok2, hdr = wait_for_ready_cache(job, cache_path, TIME_OUT_PREVIEW)
        if not ok2 then
          ya.preview_widget(job,
            ui.Text.parse("faster-piper: ⏳ preview is taking longer than expected. Try selecting the file again."):area(job.area)
          )
          return
        end
      end
    end
  else
    cache_path, why = ensure_cache(job)
    if not cache_path then
      ya.preview_widget(job, ui.Text.parse("faster-piper: " .. tostring(why)):area(job.area))
      return
    end
  end

  -- If hdr not already available/reliable, read it once here
  if not hdr then hdr, herr = read_cache_header(cache_path) end

  if hdr then
    local total = hdr.nline
    local limit = job.area.h
    local max_skip = math.max(0, total - limit)

    local skip = job.skip or 0

    if total <= PEEK_JUMP_THRESHOLD and skip > PEEK_JUMP_THRESHOLD and skip ~= max_skip then
      ya.emit("peek", { max_skip, only_if = job.file.url })
      return
    end

    if skip > max_skip then
      ya.emit("peek", { max_skip, only_if = job.file.url })
      return
    end
  else
    ya.err("faster-piper: failed to read cache header: " .. tostring(herr))
  end

  local limit = job.area.h
  local skip  = job.skip or 0

  -- content starts after HEADER.N lines of header
  local start = skip + content_first_line()
  local stop  = start + limit - 1

  local lines, err = read_line_range(tostring(cache_path), start, stop)
  if not lines then
    ya.preview_widget(job, ui.Text.parse("faster-piper: read(slice): " .. tostring(err)):area(job.area))
    return
  end

  -- The slice starts past the header, so it is pure content.
  local slice = #lines > 0 and (table.concat(lines, "\n") .. "\n") or ""

  if job.args.format == "url" then
    ya.preview_widget(job, M.format(job, split_lines(slice)))
  else
    ya.preview_widget(job, ui.Text.parse(slice):area(job.area))
  end
end

-- -------------------------------------------------------------------
-- entry(): called by `run = 'plugin faster-piper ...'` keybindings
-- -------------------------------------------------------------------
function M:entry(job)
  return
end


return M
