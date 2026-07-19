return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
	},
	{
		"saecki/crates.nvim",
		tag = "stable",
		config = function()
			require("crates").setup()
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		lazy = false,
	},
  {
    "seblyng/roslyn.nvim"
  },
}
