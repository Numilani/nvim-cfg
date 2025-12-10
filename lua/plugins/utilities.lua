return {
	-- Flash - the new AceJump alternative, jump to locs on screen via letters
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>j",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "FlashJump",
			},
		},
	},
	-- mini.nvim - a tiny utility suite
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function(_, opts)
			require("mini.ai").setup()
			require("mini.pairs").setup()
			require("mini.surround").setup()
			require("mini.cursorword").setup()
			require("mini.basics").setup()
			-- require("mini.move").setup()
		end,
	},
	-- which-key - a keystroke helper
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>??",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
		config = function()
			require("which-key").add({
				{ "<leader>?", group = "help" },
				{ "<leader>c", group = "code" },
				{ "<leader>g", group = "goto" },
				{ "<leader>f", group = "find" },
				{ "<leader>d", group = "debug" },
				{ "<leader>s", group = "surround" },
			})
		end,
	},
	-- {
	--   "akinsho/toggleterm.nvim", config = true
	-- },
	-- {
	-- 	"tpope/vim-sleuth",
	-- },
	{
		"numToStr/FTerm.nvim",
		config = true,
	},
  {
    "kawre/leetcode.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lang = "python"
    }
  },
  {
    "lewis6991/gitsigns.nvim"
  },
}
