-- Blueridge Dark Theme for Neovim
-- Mountain-inspired colorscheme with temple aesthetics

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        -- Blueridge Dark color palette
        local colors = {
          -- Base colors (dark theme)
          bg0 = '#1c2128',    -- Temple stone shadow (main background)
          bg1 = '#2c3640',    -- Deep slate shadow (slightly lighter)
          bg2 = '#3c4650',    -- Weathered stone (UI elements)
          bg3 = '#4a5568',    -- Stone highlight (selection/highlight)
          bg4 = '#5a6578',    -- Light stone (inactive elements)
          bg5 = '#6a7588',    -- Pale stone (comments/subtle)
          
          -- Foreground colors
          fg0 = '#e8e6e3',    -- Marble white (main text)
          fg1 = '#c4b5a0',    -- Papyrus (slightly dimmed text)
          fg2 = '#a8998a',    -- Subdued text
          
          -- Accent colors
          jade = '#7ea67c',      -- Jade green (balance and growth)
          turquoise = '#7ec8c8', -- Turquoise patina (primary accent)
          terracotta = '#cd9575', -- Terracotta (soft warning, not harsh red)
          gold = '#d4af37',      -- Temple gold (sacred moments)
          lavender = '#9b8aa0',  -- Dusty lavender (intuition)
          sky_blue = '#6b8cae', -- Sky through columns
          pearl = '#f4e4bc',     -- Pearl white (highest clarity)
          
          -- Special
          selection = '#4a5568',
          cursor_line = '#2c3640',
          visual = '#3c4650',
        }

        -- Reset highlighting
        vim.cmd('highlight clear')
        if vim.fn.exists('syntax_on') then
          vim.cmd('syntax reset')
        end
        
        vim.o.termguicolors = true
        vim.o.background = 'dark'
        vim.g.colors_name = 'blueridge-dark'
        
        local hl = vim.api.nvim_set_hl
        
        -- Editor highlights
        hl(0, 'Normal', { fg = colors.fg0, bg = colors.bg0 })
        hl(0, 'NormalFloat', { fg = colors.fg0, bg = colors.bg1 })
        hl(0, 'FloatBorder', { fg = colors.turquoise, bg = colors.bg1 })
        hl(0, 'FloatTitle', { fg = colors.gold, bg = colors.bg1, bold = true })
        hl(0, 'Cursor', { fg = colors.bg0, bg = colors.gold })
        hl(0, 'CursorLine', { bg = colors.cursor_line })
        hl(0, 'CursorLineNr', { fg = colors.gold, bold = true })
        hl(0, 'LineNr', { fg = colors.fg1 })
        hl(0, 'Visual', { bg = colors.visual })
        hl(0, 'VisualNOS', { bg = colors.visual })
        hl(0, 'Search', { fg = colors.bg0, bg = colors.gold })
        hl(0, 'IncSearch', { fg = colors.bg0, bg = colors.pearl })
        hl(0, 'MatchParen', { fg = colors.turquoise, bold = true })
        
        -- Syntax highlighting
        hl(0, 'Comment', { fg = colors.lavender, italic = true })
        hl(0, 'Constant', { fg = colors.turquoise })
        hl(0, 'String', { fg = colors.jade })
        hl(0, 'Character', { fg = colors.jade })
        hl(0, 'Number', { fg = colors.turquoise })
        hl(0, 'Boolean', { fg = colors.turquoise })
        hl(0, 'Float', { fg = colors.turquoise })
        hl(0, 'Identifier', { fg = colors.fg0 })
        hl(0, 'Function', { fg = colors.sky_blue })
        hl(0, 'Statement', { fg = colors.gold })
        hl(0, 'Conditional', { fg = colors.gold })
        hl(0, 'Repeat', { fg = colors.gold })
        hl(0, 'Label', { fg = colors.gold })
        hl(0, 'Operator', { fg = colors.fg1 })
        hl(0, 'Keyword', { fg = colors.gold })
        hl(0, 'Exception', { fg = colors.terracotta })
        hl(0, 'PreProc', { fg = colors.lavender })
        hl(0, 'Include', { fg = colors.lavender })
        hl(0, 'Define', { fg = colors.lavender })
        hl(0, 'Macro', { fg = colors.lavender })
        hl(0, 'PreCondit', { fg = colors.lavender })
        hl(0, 'Type', { fg = colors.sky_blue })
        hl(0, 'StorageClass', { fg = colors.sky_blue })
        hl(0, 'Structure', { fg = colors.sky_blue })
        hl(0, 'Typedef', { fg = colors.sky_blue })
        hl(0, 'Special', { fg = colors.pearl })
        hl(0, 'SpecialChar', { fg = colors.pearl })
        hl(0, 'Tag', { fg = colors.turquoise })
        hl(0, 'Delimiter', { fg = colors.fg1 })
        hl(0, 'SpecialComment', { fg = colors.lavender, italic = true, bold = true })
        hl(0, 'Debug', { fg = colors.terracotta })
        hl(0, 'Underlined', { underline = true })
        hl(0, 'Error', { fg = colors.terracotta, bold = true })
        hl(0, 'Todo', { fg = colors.gold, bold = true })
        
        -- UI elements
        hl(0, 'StatusLine', { fg = colors.fg0, bg = colors.bg2 })
        hl(0, 'StatusLineNC', { fg = colors.fg1, bg = colors.bg1 })
        hl(0, 'TabLine', { fg = colors.fg1, bg = colors.bg2 })
        hl(0, 'TabLineFill', { bg = colors.bg1 })
        hl(0, 'TabLineSel', { fg = colors.gold, bg = colors.bg0, bold = true })
        hl(0, 'Pmenu', { fg = colors.fg0, bg = colors.bg1 })
        hl(0, 'PmenuSel', { fg = colors.gold, bg = colors.bg3, bold = true })
        hl(0, 'PmenuSbar', { bg = colors.bg2 })
        hl(0, 'PmenuThumb', { bg = colors.jade })
        hl(0, 'WildMenu', { fg = colors.bg0, bg = colors.gold })
        hl(0, 'VertSplit', { fg = colors.bg3 })
        hl(0, 'WinSeparator', { fg = colors.bg3 })
        hl(0, 'Folded', { fg = colors.fg2, bg = colors.bg1 })
        hl(0, 'FoldColumn', { fg = colors.lavender, bg = colors.bg0 })
        hl(0, 'SignColumn', { fg = colors.jade, bg = colors.bg0 })
        hl(0, 'ColorColumn', { bg = colors.bg1 })
        
        -- Diff highlighting
        hl(0, 'DiffAdd', { fg = colors.jade, bg = colors.bg1 })
        hl(0, 'DiffChange', { fg = colors.gold, bg = colors.bg1 })
        hl(0, 'DiffDelete', { fg = colors.terracotta, bg = colors.bg1 })
        hl(0, 'DiffText', { fg = colors.pearl, bg = colors.bg3, bold = true })
        
        -- Git signs
        hl(0, 'GitSignsAdd', { fg = colors.jade })
        hl(0, 'GitSignsChange', { fg = colors.gold })
        hl(0, 'GitSignsDelete', { fg = colors.terracotta })
        
        -- Diagnostic highlights
        hl(0, 'DiagnosticError', { fg = colors.terracotta })
        hl(0, 'DiagnosticWarn', { fg = colors.gold })
        hl(0, 'DiagnosticInfo', { fg = colors.turquoise })
        hl(0, 'DiagnosticHint', { fg = colors.lavender })
        hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = colors.terracotta })
        hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = colors.gold })
        hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = colors.turquoise })
        hl(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = colors.lavender })
        
        -- LSP highlights
        hl(0, 'LspReferenceText', { bg = colors.bg2 })
        hl(0, 'LspReferenceRead', { bg = colors.bg2 })
        hl(0, 'LspReferenceWrite', { bg = colors.bg2, underline = true })
        
        -- Treesitter highlights
        hl(0, '@variable', { fg = colors.fg0 })
        hl(0, '@variable.builtin', { fg = colors.turquoise })
        hl(0, '@variable.parameter', { fg = colors.fg1 })
        hl(0, '@variable.member', { fg = colors.sky_blue })
        hl(0, '@constant', { fg = colors.turquoise })
        hl(0, '@constant.builtin', { fg = colors.turquoise })
        hl(0, '@constant.macro', { fg = colors.gold })
        hl(0, '@module', { fg = colors.sky_blue })
        hl(0, '@module.builtin', { fg = colors.sky_blue })
        hl(0, '@label', { fg = colors.gold })
        hl(0, '@string', { fg = colors.jade })
        hl(0, '@string.escape', { fg = colors.pearl })
        hl(0, '@string.special', { fg = colors.pearl })
        hl(0, '@string.regexp', { fg = colors.turquoise })
        hl(0, '@character', { fg = colors.jade })
        hl(0, '@character.special', { fg = colors.pearl })
        hl(0, '@boolean', { fg = colors.turquoise })
        hl(0, '@number', { fg = colors.turquoise })
        hl(0, '@number.float', { fg = colors.turquoise })
        hl(0, '@type', { fg = colors.sky_blue })
        hl(0, '@type.builtin', { fg = colors.sky_blue })
        hl(0, '@type.definition', { fg = colors.sky_blue })
        hl(0, '@attribute', { fg = colors.lavender })
        hl(0, '@property', { fg = colors.sky_blue })
        hl(0, '@function', { fg = colors.sky_blue })
        hl(0, '@function.builtin', { fg = colors.sky_blue })
        hl(0, '@function.call', { fg = colors.sky_blue })
        hl(0, '@function.macro', { fg = colors.lavender })
        hl(0, '@function.method', { fg = colors.sky_blue })
        hl(0, '@function.method.call', { fg = colors.sky_blue })
        hl(0, '@constructor', { fg = colors.sky_blue })
        hl(0, '@operator', { fg = colors.fg1 })
        hl(0, '@keyword', { fg = colors.gold })
        hl(0, '@keyword.coroutine', { fg = colors.gold })
        hl(0, '@keyword.function', { fg = colors.gold })
        hl(0, '@keyword.operator', { fg = colors.gold })
        hl(0, '@keyword.import', { fg = colors.lavender })
        hl(0, '@keyword.conditional', { fg = colors.gold })
        hl(0, '@keyword.repeat', { fg = colors.gold })
        hl(0, '@keyword.return', { fg = colors.gold })
        hl(0, '@keyword.exception', { fg = colors.terracotta })
        hl(0, '@comment', { fg = colors.lavender, italic = true })
        hl(0, '@comment.documentation', { fg = colors.lavender, italic = true })
        hl(0, '@punctuation', { fg = colors.fg1 })
        hl(0, '@punctuation.bracket', { fg = colors.fg1 })
        hl(0, '@punctuation.delimiter', { fg = colors.fg1 })
        hl(0, '@punctuation.special', { fg = colors.gold })
        hl(0, '@tag', { fg = colors.gold })
        hl(0, '@tag.attribute', { fg = colors.sky_blue })
        hl(0, '@tag.delimiter', { fg = colors.fg1 })
        
        -- Telescope
        hl(0, 'TelescopeBorder', { fg = colors.turquoise })
        hl(0, 'TelescopePromptBorder', { fg = colors.gold })
        hl(0, 'TelescopeResultsBorder', { fg = colors.jade })
        hl(0, 'TelescopePreviewBorder', { fg = colors.sky_blue })
        hl(0, 'TelescopeSelection', { fg = colors.gold, bg = colors.bg2, bold = true })
        hl(0, 'TelescopeMatching', { fg = colors.pearl, bold = true })
        
        -- Neo-tree
        hl(0, 'NeoTreeNormal', { fg = colors.fg0, bg = colors.bg0 })
        hl(0, 'NeoTreeDirectoryName', { fg = colors.sky_blue })
        hl(0, 'NeoTreeDirectoryIcon', { fg = colors.jade })
        hl(0, 'NeoTreeFileName', { fg = colors.fg0 })
        hl(0, 'NeoTreeFileIcon', { fg = colors.fg1 })
        hl(0, 'NeoTreeIndentMarker', { fg = colors.bg3 })
        hl(0, 'NeoTreeRootName', { fg = colors.gold, bold = true })
        hl(0, 'NeoTreeGitModified', { fg = colors.gold })
        hl(0, 'NeoTreeGitAdded', { fg = colors.jade })
        hl(0, 'NeoTreeGitDeleted', { fg = colors.terracotta })
        
        -- Terminal colors
        vim.g.terminal_color_0 = colors.bg1      -- Black
        vim.g.terminal_color_1 = colors.terracotta  -- Red (soft terracotta)
        vim.g.terminal_color_2 = colors.jade     -- Green
        vim.g.terminal_color_3 = colors.gold     -- Yellow
        vim.g.terminal_color_4 = colors.sky_blue -- Blue
        vim.g.terminal_color_5 = colors.lavender -- Magenta
        vim.g.terminal_color_6 = colors.turquoise -- Cyan
        vim.g.terminal_color_7 = colors.fg1      -- White
        vim.g.terminal_color_8 = colors.bg4      -- Bright Black
        vim.g.terminal_color_9 = '#daa89b'       -- Bright Red (brighter terracotta)
        vim.g.terminal_color_10 = '#93c293'      -- Bright Green
        vim.g.terminal_color_11 = colors.pearl   -- Bright Yellow (pearl)
        vim.g.terminal_color_12 = '#8fb4d8'      -- Bright Blue
        vim.g.terminal_color_13 = '#b4a3ba'      -- Bright Magenta
        vim.g.terminal_color_14 = '#9bdede'      -- Bright Cyan
        vim.g.terminal_color_15 = colors.fg0     -- Bright White
      end,
    },
  },
}