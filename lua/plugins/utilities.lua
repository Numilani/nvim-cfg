return {
	-- mason-tool-installer - ensure all the LSPs are installed
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"bash-language-server",
					"black",
					"blue",
					"clang-format",
					"csharpier",
					"css-lsp",
					"debugpy",
					"delve",
					"google-java-format",
					"gopls",
					"html-lsp",
					"htmlbeautifier",
					"htmlhint",
					"java-debug-adapter",
					"jdtls",
					"js-debug-adapter",
					"json-lsp",
					"jsonlint",
					"kotlin-lsp",
					"ktfmt",
					"ktlint",
					"netcoredbg",
					"powershell-editor-services",
					"prettier",
					"prettierd",
					"pylint",
					"roslyn-language-server",
					"standardjs",
					"stylua",
					"ts-standard",
					"typescript-language-server",
					"vale",
					"zuban",
				},
				run_on_start = false,
				start_delay = 3000,
				debounce_hours = 0,
			})
		end,
	},
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
			require("mini.pairs").setup()
			require("mini.surround").setup()
			require("mini.cursorword").setup()
			require("mini.basics").setup()
			require("mini.bufremove").setup()
		end,
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			rename = { enabled = true },
		},
	},
	-- listish - handle quicklist/loclist more gracefully
	{
		"arsham/listish.nvim",
		dependencies = {
			"arsham/arshlib.nvim",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = {
			quickfix = {
				on_cursor = "<leader>qa",
			},
			loclist = {
				open = "<leader>lo",
				on_cursor = "<leader>la",
				add_note = "<leader>ln",
				clear = "<leader>ld",
				close = "<leader>lc",
				next = "]l",
				prev = "[l",
			},
		},
	},
	-- marks - clearer mark displays and handling
	{
		"chentoast/marks.nvim",
		event = "VeryLazy",
		opts = {},
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
	{
		"numToStr/FTerm.nvim",
		config = function()
			local cfg = {}
			if vim.g.is_windows then
				require("FTerm").setup({
					cmd = "powershell",
				})
			end
		end,
	},
	{
		"kawre/leetcode.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			lang = "python",
		},
	},
	{
		"lewis6991/gitsigns.nvim",
	},
	{
		"chrisgrieser/nvim-recorder",
		dependencies = "rcarriga/nvim-notify",
		opts = {
			dynamicSlots = "rotate",
		},
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		opts = {
			preview = {
				filetypes = { "markdown", "codecompanion" },
				ignore_buftypes = {},
			},
		},
	},
}
