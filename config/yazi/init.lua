-- bunny (hops/bookmarks)
require("bunny"):setup({
  hops = {
    { key = "/", path = "/",                            desc = "Root" },
    { key = ";", path = "~",                            desc = "Home" },
    { key = "h", path = "~/.config/hypr/",              desc = "Hyprland" },
    { key = "m", path = "~/Music/",                     desc = "Music" },
    { key = "b", path = "~/.local/share/calos/bin/",    desc = "Binaries" },
    { key = "c", path = "~/.config",                    desc = "Config" },
    { key = "t", path = "~/.local/share/calos/themes/", desc = "Themes" },
    { key = "p", path = "~/Pictures",                   desc = "Pictures" },
    { key = "d", path = "~/Downloads",                  desc = "Downloads" },
    { key = "v", path = "~/Videos/",                    desc = "Videos" },
    { key = "w", path = "~/wksp/",                      desc = "Workspace" },
    { key = "s", path = "/mnt/storage/",                desc = "Storage" },
    { key = "r", path = "~/.local/share/Trash/",        desc = "Recycle Bin" },
    { key = "q", path = "~/.config/quickshell/",        desc = "Quickshell" }
    -- key and path attributes are required, desc is optional
  },
  desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
  ephemeral = true,       -- Enable ephemeral hops, default is true
  tabs = true,            -- Enable tab hops, default is true
  notify = true,          -- Notify after hopping, default is false
  fuzzy_cmd = "fzf",      -- Fuzzy searching command, default is "fzf"
})

-- full-border
require("full-border"):setup()

require("eza-preview"):setup({
  -- Set the tree preview to be default (default: true)
  default_tree = true,

  -- Directory depth level for tree preview (default: 3)
  level = 1,

  -- Show file icons
  icons = true,

  -- Follow symlinks when previewing directories (default: true)
  follow_symlinks = true,

  -- Show target file info instead of symlink info (default: false)
  dereference = false,

  -- Show hidden files (default: true)
  all = true,

  -- Ignore files matching patterns (default: {})
  -- ignore_glob = "*.log"
  -- ignore_glob = { "*.tmp", "node_modules", ".git", ".DS_Store" }
  -- SEE: https://www.linuxjournal.com/content/pattern-matching-bash to learn about glob patterns
  ignore_glob = {},

  -- Ignore files mentioned in '.gitignore'  (default: true)
  git_ignore = true,

  -- Show git status (default: false)
  git_status = false,
})
