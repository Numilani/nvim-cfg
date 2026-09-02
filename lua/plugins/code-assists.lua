return {
	-- blink.cmp is a blazing-fast completion engine.
	-- It has lots of configurable features, many of which are not enabled for this minimalist setup.
	-- More info: https://cmp.saghen.dev
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		opts = {
			keymap = {
				preset = "none",
				["<C-c>"] = { "show", "hide" },
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
	-- friendly-snippets is just some code snips to make autocompletes better
	{
		"rafamadriz/friendly-snippets",
	},
	-- nvim-treesitter is what provides syntax highlighting.
	-- It can even be used without LSPs, relying instead on syntax trees!
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		main = "nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		opts = {
			install_dir = vim.fn.stdpath("data") .. "/site",
			indent = { enable = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},
	-- ts-autotag handles automatic closing of tags (i.e. html tags).
	{
		"windwp/nvim-ts-autotag",
		lazy = false,
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable = true,
					enable_close = true,
					enable_rename = true,
					filetypes = {
						"html",
						"xml",
						"js",
						"jsx",
						"typescript",
						"ts",
						"tsx",
						"javascriptreact",
						"typescriptreact",
					},
				},
				aliases = {
					["razor"] = "html",
				},
			})
		end,
	},
	-- grug-far provides a cleaner UI for handling workspace-wide search and replace!
	{
		"MagicDuck/grug-far.nvim",
		keys = {
			{ "<leader>fr", "<cmd>GrugFar<CR>", desc = "Find/Replace" },
		},
	},
	-- trouble provides a cleaner interface for viewing various LSP-related info
	{
		"folke/trouble.nvim",
		opts = {
			win = {
				size = 0.5,
			},
		},
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
	-- this just highlights brace pairs with colors to make it easier to see which sets pair up :)
	{
		"HiPhish/rainbow-delimiters.nvim",
	},
	-- conform handles code formatting, working with and without LSPs.
	-- Highly configurable, just use Mason to install a formatter and set it up here.
	{
		"stevearc/conform.nvim",
		keys = {
			{
				"<leader>cf",
				mode = { "n", "v" },
				function()
					require("conform").format({ lsp_fallback = true, async = true, timeout_ms = 1500 })
				end,
				desc = "Format",
			},
		},
		config = function(_, opts)
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					-- cs = { "csharpier" },
					java = { "google-java-format" },
					python = { "black" },
					html = { "htmlbeautifier" },
					javascript = { "prettier", "eslint_d", lsp_format = "never" },
					javascriptreact = { "prettier", "eslint_d", lsp_format = "never" },
					typescript = { "prettier", "eslint_d", lsp_format = "never" },
					typescriptreact = { "prettier", "eslint_d", lsp_format = "never" },
					json = { "prettier" },
				},
				format_on_save = {
					timeout_ms = 1500,
					lsp_format = "fallback",
				},
				default_format_opts = {
					lsp_format = "prefer",
				},
			})
			require("conform").formatters.injected = {
				options = {
					ignore_errors = true,
				},
			}
		end,
	},
	-- nvim-lint is to linters what conform is to formatters. same deal here.
	{
		"mfussenegger/nvim-lint",
		config = function(_, opts)
			require("lint").linters_by_ft = {
				markdown = { "vale" },
				python = { "pylint" },
				html = { "htmlhint" },
			}
		end,
	},
    -- Neotest used to live here.
    -- Neotest is slow, and turned out to be slowing the whole experience down.
    -- I have removed neotest. RIP. 
    -- Instead, I suggest setting up testing through tasks.json or overseer.
	
}
