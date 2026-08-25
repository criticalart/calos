return {
  {
    "bjarneo/aether.nvim",
    name = "aether",
    priority = 1000,
    opts = {
      disable_italics = false,
      colors = {
        -- Monotone shades (base00-base07)
        base00 = "#292526", -- Default background
        base01 = "#402b2d", -- Lighter background / status bars
        base02 = "#34292a", -- Selection background
        base03 = "#7c5658", -- Comments, invisibles
        base04 = "#b99b9c", -- Dark foreground
        base05 = "#dcd6d6", -- Default foreground
        base06 = "#e2dcdc", -- Light foreground
        base07 = "#eee8e8", -- Light background

        -- Accent colors (base08-base0F)
        base08 = "#b77a7c", -- Variables, errors, red
        base09 = "#ae7476", -- Integers, constants, orange
        base0A = "#a9797a", -- Classes, types, yellow
        base0B = "#8f696a", -- Strings, green
        base0C = "#9f7779", -- Support, regex, cyan
        base0D = "#9f6769", -- Functions, keywords, blue
        base0E = "#ad7d7f", -- Keywords, storage, magenta
        base0F = "#806063", -- Deprecated, brown/yellow
      },
    },
    config = function(_, opts)
      require("aether").setup(opts)
      vim.cmd.colorscheme("aether")

      -- Enable hot reload
      require("aether.hotreload").setup()
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether",
    },
  },
}
