--- @since 25.12.29

local M = {}

-- Batch getter - returns multiple simple values (avoids multiple sync boundary crossings)
local get_all_opts = ya.sync(function(st)
	return st.tree ~= false,
		st.level or 3,
		st.follow_symlinks ~= false,
		st.dereference == true,
		st.all ~= false,
		st.git_ignore ~= false,
		st.git_status == true,
		st.icons ~= false,
		st.ignore_glob or ""
end)

-- Individual getters for entry point (need current value before toggling)
local get_tree = ya.sync(function(st) return st.tree ~= false end)
local get_level = ya.sync(function(st) return st.level or 3 end)
local get_follow_symlinks = ya.sync(function(st) return st.follow_symlinks ~= false end)
local get_all = ya.sync(function(st) return st.all ~= false end)
local get_git_ignore = ya.sync(function(st) return st.git_ignore ~= false end)
local get_git_status = ya.sync(function(st) return st.git_status == true end)

-- Sync setters (also trigger preview refresh)
local set_tree = ya.sync(function(st, val)
	st.tree = val
	local h = cx.active.current.hovered
	if h then ya.emit("peek", { 0, only_if = h.url, force = true }) end
end)
local set_level = ya.sync(function(st, val)
	st.level = val
	local h = cx.active.current.hovered
	if h then ya.emit("peek", { 0, only_if = h.url, force = true }) end
end)
local set_follow_symlinks = ya.sync(function(st, val)
	st.follow_symlinks = val
	local h = cx.active.current.hovered
	if h then ya.emit("peek", { 0, only_if = h.url, force = true }) end
end)
local set_all = ya.sync(function(st, val)
	st.all = val
	local h = cx.active.current.hovered
	if h then ya.emit("peek", { 0, only_if = h.url, force = true }) end
end)
local set_git_ignore = ya.sync(function(st, val)
	st.git_ignore = val
	local h = cx.active.current.hovered
	if h then ya.emit("peek", { 0, only_if = h.url, force = true }) end
end)
local set_git_status = ya.sync(function(st, val)
	st.git_status = val
	local h = cx.active.current.hovered
	if h then ya.emit("peek", { 0, only_if = h.url, force = true }) end
end)

-- Setup from user config
local apply_config = ya.sync(function(st, cfg)
	cfg = cfg or {}
	if cfg.default_tree ~= nil then st.tree = cfg.default_tree end
	if cfg.level ~= nil then st.level = cfg.level end
	if cfg.follow_symlinks ~= nil then st.follow_symlinks = cfg.follow_symlinks end
	if cfg.dereference ~= nil then st.dereference = cfg.dereference end
	if cfg.all ~= nil then st.all = cfg.all end
	if cfg.git_ignore ~= nil then st.git_ignore = cfg.git_ignore end
	if cfg.git_status ~= nil then st.git_status = cfg.git_status end
	if cfg.icons ~= nil then st.icons = cfg.icons end
	if cfg.ignore_glob ~= nil then
		if type(cfg.ignore_glob) == "table" then
			st.ignore_glob = table.concat(cfg.ignore_glob, "|")
		else
			st.ignore_glob = cfg.ignore_glob
		end
	end
end)

function M:setup(cfg)
	apply_config(cfg)
end

function M:entry(job)
	local args = string.gsub(job.args[1] or "", "^%s*(.-)%s*$", "%1")
	if args == "inc-level" then
		set_level(get_level() + 1)
	elseif args == "dec-level" then
		local lvl = get_level()
		if lvl > 1 then set_level(lvl - 1) end
	elseif args == "toggle-follow-symlinks" then
		set_follow_symlinks(not get_follow_symlinks())
	elseif args == "toggle-hidden" then
		set_all(not get_all())
	elseif args == "toggle-git-ignore" then
		set_git_ignore(not get_git_ignore())
	elseif args == "toggle-git-status" then
		set_git_status(not get_git_status())
	else
		set_tree(not get_tree())
	end
end

function M:peek(job)
	-- Single sync call to get all options (avoids 9 separate boundary crossings)
	local is_tree, level, follow_symlinks, dereference, all, git_ignore, git_status, icons, ignore_glob = get_all_opts()

	local args = {
		"--color=always",
		"--group-directories-first",
		"--no-quotes",
		tostring(job.file.url),
	}
	if is_tree then
		table.insert(args, "--tree")
		table.insert(args, string.format("--level=%d", level))
	end
	if icons then
		table.insert(args, "--icons=always")
	end
	if follow_symlinks then
		table.insert(args, "--follow-symlinks")
	end
	if all then
		table.insert(args, "--all")
	end
	if dereference then
		table.insert(args, "--dereference")
	end
	if git_status then
		table.insert(args, "--long")
		table.insert(args, "--no-permissions")
		table.insert(args, "--no-user")
		table.insert(args, "--no-time")
		table.insert(args, "--no-filesize")
		table.insert(args, "--git")
		table.insert(args, "--git-repos")
	end
	if git_ignore then
		table.insert(args, "--git-ignore")
	end
	if ignore_glob ~= "" then
		table.insert(args, "-I")
		table.insert(args, ignore_glob)
	end

	local child, err = Command("eza"):arg(args):stdout(Command.PIPED):stderr(Command.PIPED):spawn()
	if not child then
		return ya.preview_widget(job, ui.Text("eza: " .. (err or "spawn failed")):area(job.area))
	end

	local limit = job.area.h
	local lines = ""
	local line_count = 0
	local skipped = 0

	repeat
		local line, event = child:read_line()
		if event == 1 then
			-- stderr, skip
		elseif event ~= 0 then
			break
		elseif skipped < job.skip then
			skipped = skipped + 1
		else
			lines = lines .. line
			line_count = line_count + 1
		end
	until line_count >= limit

	child:start_kill()

	-- tree mode outputs dir name as first line, so empty = 1 line; list mode empty = 0 lines
	local empty_output = (is_tree and line_count <= 1) or (not is_tree and line_count == 0)

	if job.skip > 0 and line_count < limit then
		ya.emit("peek", {
			math.max(0, job.skip - (limit - line_count)),
			only_if = job.file.url,
			upper_bound = true,
		})
	elseif empty_output then
		ya.preview_widget(job, {
			ui.Text({ ui.Line("No items") }):area(job.area):align(ui.Text.CENTER),
		})
	else
		ya.preview_widget(job, {
			ui.Text.parse(lines):area(job.area),
		})
	end
end

function M:seek(job)
	local h = cx.active.current.hovered
	if h and h.url == job.file.url then
		local step = math.floor(job.units * job.area.h / 10)
		ya.emit("peek", {
			math.max(0, cx.active.preview.skip + step),
			only_if = job.file.url,
			force = true,
		})
	end
end

return M
