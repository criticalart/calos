# eza-preview.yazi

[Yazi](https://github.com/sxyazi/yazi) plugin to preview directories using [eza](https://github.com/eza-community/eza), can be switched between list and tree modes.

List mode:
![list.png](list.png)

Tree mode:
![tree.png](tree.png)

## Requirements

- [yazi (26.1.4+) or nightly](https://github.com/sxyazi/yazi)
- [eza (0.20+)](https://github.com/eza-community/eza)

## Installation

```sh
ya pkg add ahkohd/eza-preview
```

## Usage

### Basic Setup

Add `eza-preview` to previewers in `yazi.toml`:

```toml
[[plugin.prepend_previewers]]
url = "*/"
run = "eza-preview"
```

### Key Bindings

Set key bindings to control the preview in `keymap.toml`:

```toml
[mgr]
prepend_keymap = [
  { on = [ "e", "t" ], run = "plugin eza-preview",  desc = "Toggle tree/list dir preview" },
  { on = [ "e", "-" ], run = "plugin eza-preview inc-level", desc = "Increment tree level" },
  { on = [ "e", "_" ], run = "plugin eza-preview dec-level", desc = "Decrement tree level" },
  { on = [ "e", "$" ], run = "plugin eza-preview toggle-follow-symlinks", desc = "Toggle tree follow symlinks" },
  { on = [ "e", "*" ], run = "plugin eza-preview toggle-hidden", desc = "Toggle hidden files" },
  { on = [ "e", "g", "i" ], run = "plugin eza-preview toggle-git-ignore", desc = "Toggle .gitignore files" },
  { on = [ "e", "g", "s" ], run = "plugin eza-preview toggle-git-status", desc = "Toggle showing git status" },
]
```

### Configuration

Configure the plugin in `init.lua`:

```lua
require("eza-preview"):setup({
  -- Set the tree preview to be default (default: true)
  default_tree = true,

  -- Directory depth level for tree preview (default: 3)
  level = 3,

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
  git_status = false
})

-- Or use default settings
require("eza-preview"):setup({})
```

## Available Commands

- `plugin eza-preview` - Toggle between tree and list modes
- `plugin eza-preview inc-level` - Increase tree depth level
- `plugin eza-preview dec-level` - Decrease tree depth level
- `plugin eza-preview toggle-follow-symlinks` - Toggle symlink following
- `plugin eza-preview toggle-hidden` - Toggle hidden file visibility
- `plugin eza-preview toggle-git-ignore` - Toggle ignore files mentioned in '.gitignore'
- `plugin eza-preview toggle-git-status` - Toggle showing git status

## Contributing

Feel free to contribute by opening issues or submitting pull requests!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
