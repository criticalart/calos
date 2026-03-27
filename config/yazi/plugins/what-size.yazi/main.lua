--- @since 25.5.28
-- This plugin is now only supporting Yazi's version 25.5.28 or newer
-- since commit https://github.com/sxyazi/yazi/pull/2695

-- TODO: Asynchronous calculating and dynamic displaying in statusline,
-- perhaps by using this:
--      https://yazi-rs.github.io/docs/plugins/utils/#ps.sub
-- and by using ui.render() method
-- See also:
--      https://github.com/sxyazi/yazi/pull/1903
--      https://yazi-rs.github.io/docs/dds/#kinds
--      https://github.com/sxyazi/yazi/pull/2210
--      https://github.com/imsi32/yatline.yazi
-- TODO: Add options to choose displaying in popup box or in statusline
-- TODO: Add spotter and previewer widget to support simpler displaying
-- TODO: Remove note [1] and [2] after add them to the setup
-- configuration

-- Get selected paths {{{1
local get_selected_paths = ya.sync(function(state)
    local result = {}
    if cx and cx.active and cx.active.selected then
        for _, url in pairs(cx.active.selected) do
            result[#result + 1] = url
        end
    end
    return result
end)
-- }}}1
-- Get current working directory in sync context {{{1
local get_cwd = ya.sync(function(state)
    if cx and cx.active and cx.active.current and cx.active.current.cwd then
        return cx.active.current.cwd
    end
    return nil
end)
-- }}}1
-- Function to get paths of selected files or current directory {{{1
--- @param selected table Table of selected urls
--- @return paths table Table of selected urls
local function get_paths(selected)
    -- If no files are selected, get current directory
    if #selected == 0 then
        local paths = {}
        -- Try fs.cwd() first (async, optimized for slow devices)
        local cwd, err = fs.cwd()
        if cwd then
            paths[1] = cwd
        else
            -- Fallback to cx.active.current.cwd (via sync block)
            local sync_cwd = get_cwd()
            if sync_cwd then
                paths[1] = sync_cwd
            else
                ya.notify {
                    title = "What size",
                    content = "Cannot get current working directory: " .. (err or "unknown error"),
                    timeout = 5,
                    level = "error",
                }
            end
        end
        return paths
    else
        -- This variable is a table of urls already
        return selected
    end
end
-- }}}1
-- Function to get total size using Yazi's fs.calc_size API {{{1
-- See: https://github.com/sxyazi/yazi/pull/2695
-- See: https://github.com/sxyazi/yazi/blob/main/yazi-plugin/preset/plugins/folder.lua
local function get_total_size(items)
    local total = 0
    for _, url in ipairs(items) do
        local it = fs.calc_size(url)
        while true do
            local next = it:recv()
            if next then
                total = total + next
            else
                break
            end
        end
    end
    return total
end
-- }}}1
-- Function to format files/folders size {{{1
local function format_size(size)
    local units = { "B", "KB", "MB", "GB", "TB" }
    local unit_index = 1
    while size > 1024 and unit_index < #units do
        size = size / 1024
        unit_index = unit_index + 1
    end
    return string.format("%.2f %s", size, units[unit_index])
end
-- }}}1
-- Generic setter for any state field {{{1
local set_state = ya.sync(function(state, field, value)
    state[field] = value
end)
-- }}}1
-- Generic getter for any state field {{{1
local get_state = ya.sync(function(state, field)
    return state[field] or nil
end)
-- }}}1
-- Get selecting state {{{1
local get_selected = ya.sync(function()
    return (not cx.active.mode.is_visual) and (#cx.active.selected ~= 0)
end)
-- }}}1
-- Set separators {{{1
local set_separator = ya.sync(function(state, table)
    if table and table.LEFT and table.RIGHT then
        state.LEFT = table.LEFT
        state.RIGHT = table.RIGHT
    else
        state.LEFT = " "
        state.RIGHT = " "
    end
end)
-- }}}1
-- Get separators {{{1
local get_separator = ya.sync(function(state)
    return {state.LEFT, state.RIGHT}
end)
-- }}}1
-- Redraw statusline {{{1
local redraw_statusline = ya.sync(function(state)
    ui.render()
end)
-- }}}1
-- Set ui line in statusline for size, clean up when no selection exists {{{1
-- @return of get_state("renewed_state") number or nil Returning -1
--     means never show the size - suitable for setup function;
--     returning 0 means the size will be shown after triggering the
--     calculation, but without unselect the selections, or it will be
--     hidden after nothing is selected; returning 1 means hidden when
--     nothing is selected as said.
local set_ui_line = function(state)
    local sep_left, sep_right = table.unpack(get_separator())

    if get_state("renewed_state") == -1 then
        return ""
    else
        if not get_selected() then
            if not get_state("is_held") then
                set_state("renewed_state", 1)
                return ""
            end
            -- NOTE [1]: Set this line if DON'T want to clear the value
            -- in the statusline when move the cursor, after calculating
            -- with NO selection(s). Or just return ""
            return ui.Span(sep_left .. get_state("size") .. sep_right)
        end
        if get_state("renewed_state") == 0 then
            return ui.Span(sep_left .. get_state("size") .. sep_right)
        else
            -- NOTE [2]: Set this line if want to clear the value in the
            -- statusline when move the cursor, after calculating WITH
            -- selection: return ui.Span(sep_left .. get_state("size") .. sep_right)
            -- or just remove after the unselection like below
            return ""
        end
    end
end
-- }}}1

--- @since 25.12.29
return {
    entry = function(self, job)
        local clipboard = job.args.clipboard or job.args[1] == '-c'

        local selected = get_selected_paths()
        local prepend_msg
        -- Keep showing the size after CWD calculation (no selections)
        if #selected == 0 then
            set_state("is_held", true)
            prepend_msg = "Current Dir: "
        else
            set_state("is_held", false)
            prepend_msg = "Selected: "
        end

        local items = get_paths(selected)
        if not items or #items == 0 then
            ya.notify {
                title = "What size",
                content = "Failed to get paths",
                timeout = 5,
            }
            return
        end

        local total_size = get_total_size(items)
        if not total_size then
            ya.notify {
                title = "What size",
                content = "Failed to calculate size",
                timeout = 5,
            }
            return
        end

        local formatted_size = format_size(total_size)

        local notification_content = prepend_msg .. formatted_size
        if clipboard then
            ya.clipboard(formatted_size)
            notification_content = notification_content .. "\nCopied to clipboard."
        end
        ya.notify {
            title = "What size",
            content = notification_content,
            timeout = 4,
        }

        set_state("size", formatted_size)
        set_state("renewed_state", 0)
        redraw_statusline()
    end,

    setup = function(state, opts)
        opts = opts or {}
        local priority = opts.priority or 400
        set_separator(opts)
        set_state("renewed_state", -1)

        if Status and type(Status.children_add) == "function" then
            Status:children_add(set_ui_line, priority, Status.RIGHT)
        else
            ya.err("Failed to initialize status bar: Status or children_add not available")
        end
    end,
}
