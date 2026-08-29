return {
	-- tokyonight - color theme!
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = { style = "moon" },
	},
	{
		"bluz71/vim-moonfly-colors",
		name = "moonfly",
		lazy = false,
		priority = 1000,
	},
	{
		"NLKNguyen/papercolor-theme",
		lazy = false,
		priority = 1000,
	},
	{
		"tomasr/molokai",
		lazy = false,
		priority = 1000,
	},
	-- diagflow displays diagnostics in the top-right corner of the screen.
	-- {
	-- 	"dgagn/diagflow.nvim",
	-- },
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup({
                options = {
                    multilines = {
                        enabled = true,
                        always_show = true,
                        severity = {vim.diagnostic.severity.ERROR}
                    }
                }
            })
			vim.diagnostic.config({ virtual_text = false })
		end,
	},
	-- todo-comments - highlight TODO, NOTE, and other annotations!
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"[",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous TODO",
			},
			{
				"]",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next TODO",
			},
		},
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = true,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			theme = "base16",
		},
		config = true,
	},
	-- nicely fullscreens a window - kinda surprised this requires a plugin, actually
	{
		"szw/vim-maximizer",
		keys = {
			{ "<F12>", "<cmd>MaximizerToggle<CR>", desc = "Fullscreen current window" },
		},
	},
	-- Noice - new UI design for infoboxes (use :noice instead of :messages)
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				messages = {
					enabled = true,
					view = "mini",
					view_error = "notify",
					view_warn = "notify",
					view_search = "virtualtext",
				},
				lsp = {
					progress = {
						enabled = true,
						format = "lsp_progress",
						format_done = "lsp_progress_done",
						throttle = 1000 / 30,
						view = "mini",
					},
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = false,
					lsp_doc_border = false,
				},
			})
		end,
	},
}
