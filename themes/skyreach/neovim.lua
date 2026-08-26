-- Blueridge Dark Theme for Neovim
-- Mountain-inspired colorscheme with temple aesthetics

return {
	{
		"shaunsingh/nord.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "nord",
		},
	},
}
