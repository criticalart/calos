-- bunny (hops/bookmarks)
require("bunny"):setup({
	hops = {
		{ key = "/", path = "/", desc = "Root" },
		{ key = "h", path = "~", desc = "Home" },
		{ key = "m", path = "/mnt", desc = "Mount" },
		{ key = "b", path = "/boot", desc = "Boot" },
		{ key = "c", path = "~/.config", desc = "Config" },
		{ key = "t", path = "~/.local/share/calos/themes/", desc = "Themes" },
		{ key = "w", path = "~/wksp/", desc = "Workspace" },
		{ key = "g", path = "~/.local/share/Steam/steamapps/common", desc = "Steam Games" },
		{ key = "d", path = "~/Downloads", desc = "Downloads" },
		-- key and path attributes are required, desc is optional
	},
	desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
	ephemeral = true, -- Enable ephemeral hops, default is true
	tabs = true, -- Enable tab hops, default is true
	notify = true, -- Notify after hopping, default is false
	fuzzy_cmd = "fzf", -- Fuzzy searching command, default is "fzf"
})

-- full-border
require("full-border"):setup()

-- folder-size
require("current-size"):setup({
	equal_ignore = { "~", "/", "/home" }, -- full path match
	-- sub_ignore = {"~/deskenv/master","~/deskenv/dev"} -- sub path match
})
