# what-size.yazi

A plugin for [yazi](https://github.com/sxyazi/yazi) to calculate the size of the current selection or the current working directory (if no selection is made).

## Compatibility

what-size supports Yazi on Linux, macOS, and Windows.

### OS

- Linux since first commit
- macOS since commit `42c6a0e` ([link](https://github.com/pirafrank/what-size.yazi/commit/42c6a0efb7245badb16781da5380be1a1705f3f2))
- Windows since commit `4a56ead` ([link](https://github.com/pirafrank/what-size.yazi/commit/4a56ead2a84c5969791fb17416e0b451ab906c5d))

### Yazi

In an effort to make things easy, I keep `compatibility/yazi-x.y.z` branches with each pointing to the most up-to-date commit compatible with yazi release `x.y.z`. Full table below.

|Yazi releases|what-size branch name|
|---|---|
|*[latest stable](https://github.com/sxyazi/yazi/releases/latest)*|`main`|
|`25.5.28`-`26.5.6`|`compatibility/yazi-25.5.28`|
|`25.x`-`25.4.8`|`compatibility/yazi-25.4.8`|
|`0.4.x`|`compatibility/yazi-0.4.x`|
|`0.3.x`|`compatibility/yazi-0.3.x`|

Please notice that `nightly` releses may work but are not explicitly supported.

## Requirements

### Before Yazi's version 25.5.28

- Use this commit: [Old version](https://github.com/pirafrank/what-size.yazi/commit/d8966568f2a80394bf1f9a1ace6708ddd4cc8154)
- `du` on Linux and macOS
- PowerShell on Windows

### On Yazi's version 25.5.28 or newer

- No requirement

## Installation

```sh
ya pkg add pirafrank/what-size
```

or (**DEPRECATED** - use only for yazi `25.4.8` and older):

```sh
ya pack -a 'pirafrank/what-size'
```

## Usage

### Keymap

Add this to your `~/.config/yazi/keymap.toml`:

```toml
[[mgr.prepend_keymap]]
on = [ ".", "s" ]
run  = "plugin what-size"
desc = "Calc size of selection or cwd" 
```

If you want to copy the result to clipboard, you can add `--clipboard` or `-c` as 2nd positional argument:

```toml
[[mgr.prepend_keymap]]
on   = [ ".", "s" ]
run  = "plugin what-size -- '--clipboard'"
desc = "Calc size of sel/cwd + paste to clipboard"
```

```toml
[[mgr.prepend_keymap]]
on = [ ".", "s" ]
run = "plugin what-size -- '-c'"
desc = "Calc size of sel/cwd + paste to clipboard"
```

Change to whatever keybinding you like.

### User interface (optional)

If you want to place the size value exactly where you want, modify the priority value. Also changing two strings `LEFT` and `RIGHT` will add them to the left and right side of the value. Remember to add to and change these lines inside your `init.lua` file if you want to customize, or the plugin will use this configuration by default:

```lua
require("what-size"):setup({
    priority = 400,
    LEFT = "",
    RIGHT = " ",
})
```

## Feedback

If you have any feedback, suggestions, or ideas please let me know by opening an issue.

## Dev setup

Check the debug config [here](https://yazi-rs.github.io/docs/plugins/overview/#debugging).

To get debug logs while develoing use `ya.dbg()` in your code, then set the `YAZI_LOG` environment variable to `debug` before running Yazi.

```sh
YAZI_LOG=debug yazi
```

Logs will be saved to `~.local/state/yazi/yazi.log` file.

### Plugin definition

The repo already has a `.luarc.json` file. You only need to run the following to add the `types` plugin dependency:

```sh
ya pkg add yazi-rs/plugins:types
```

as per the [docs](https://github.com/yazi-rs/plugins/tree/main/types.yazi).

## Contributing

Contributions are welcome. Please fork the repository and submit a PR.

## License

MIT
