return {
  {
    "tahayvr/matteblack.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "matteblack",
    },
  },

  {
    "LazyVim/LazyVim",
    opts = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "matteblack",
        callback = function()
          vim.api.nvim_set_hl(0, "Visual", {
            bg = "#8A4A3A",
            fg = "#FAFAFA",
          })

          vim.api.nvim_set_hl(0, "@variable", {
            fg = "#D0D0D0",
          })

          vim.api.nvim_set_hl(0, "@variable.member", {
            fg = "#B8B8B8",
          })

          vim.api.nvim_set_hl(0, "@property", {
            fg = "#B8B8B8",
          })

          vim.api.nvim_set_hl(0, "@lsp.type.property", {
            fg = "#B8B8B8",
          })

          vim.api.nvim_set_hl(0, "@function.call", {
            fg = "#D0D0D0",
          })

          vim.api.nvim_set_hl(0, "@function.method", {
            fg = "#C0C0C0",
          })

          vim.api.nvim_set_hl(0, "Special", {
            fg = "#995344",
          })

          vim.api.nvim_set_hl(0, "Boolean", {
            fg = "#995344",
          })
          vim.api.nvim_set_hl(0, "@constant", {
            fg = "#A65A48",
          })

          vim.api.nvim_set_hl(0, "@variable.builtin", {
            fg = "#995344",
          })
          vim.api.nvim_set_hl(0, "@boolean", {
            fg = "#995344",
          })

          vim.api.nvim_set_hl(0, "Type", {
            fg = "#C0C0C0",
          })

          vim.api.nvim_set_hl(0, "Statement", {
            fg = "#B8B8B8",
          })

          vim.api.nvim_set_hl(0, "Keyword", {
            fg = "#C0C0C0",
          })

          vim.api.nvim_set_hl(0, "@keyword", {
            fg = "#995344",
          })
          vim.api.nvim_set_hl(0, "@punctuation.special", {
            fg = "#A65A48",
          })
          vim.api.nvim_set_hl(0, "@keyword.conditional", {
            fg = "#B8B8B8",
          })

          vim.api.nvim_set_hl(0, "@keyword.function", {
            fg = "#8A4A3A",
          })

          vim.api.nvim_set_hl(0, "@keyword.repeat", {
            fg = "#8A4A3A",
          })
          vim.api.nvim_set_hl(0, "@keyword.import", {
            fg = "#A65A48",
          })
          vim.api.nvim_set_hl(0, "@keyword.directive", {
            fg = "#A65A48",
          })
          vim.api.nvim_set_hl(0, "@keyword.return", {
            fg = "#8A4A3A",
          })

          vim.api.nvim_set_hl(0, "@string.regex", {
            fg = "#8C8C8C",
          })
        end,
      })
    end,
  },
}
