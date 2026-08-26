return {
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		opts = {
			keymap = {
				preset = "none",
				["<C-c>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-j>"] = { "select_next", "fallback_to_mappings" },
				["<C-k>"] = { "select_prev", "fallback_to_mappings" },
				["<Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.accept()
						else
							return cmp.select_and_accept()
						end
					end,
					"snippet_forward",
					"fallback",
				},
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = { documentation = { auto_show = true, auto_show_delay_ms = 1000 } },
			sources = {
				providers = {
					lsp = {
						min_keyword_length = 0,
					},
				},
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = { sorts = { "score", "sort_text", "kind" }, implementation = "prefer_rust_with_warning" },
			signature = { enabled = true },
		},
		opts_extend = { "sources.default" },
	},
	{
		"dgagn/diagflow.nvim",
		config = function()
			require("diagflow").setup()
		end,
	},
	{
		"stevearc/overseer.nvim",
		config = function()
			require("overseer").setup()
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {
			win = {
				size = 0.5,
			},
		}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>cD",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Workspace Diagnostics",
			},
			{
				"<leader>cd",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false win.position=left<cr>",
				desc = "Class Symbols",
			},
			{
				"<leader>cu",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "Find Usages...",
			},
			{
				"<leader>ct",
				"<cmd>Trouble todo toggle win.position=right<cr>",
				desc = "Show Todos",
			},
			-- {
			-- 	"<leader>cl",
			-- 	"<cmd>Trouble loclist toggle<cr>",
			-- 	desc = "LocList",
			-- },
			-- {
			-- 	"<leader>cq",
			-- 	"<cmd>Trouble qflist toggle<cr>",
			-- 	desc = "QFList",
			-- },
		},
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
	},
}
