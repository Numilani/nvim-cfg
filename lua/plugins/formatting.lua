return {
	{
		"stevearc/conform.nvim",
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format Code",
			},
		},
		config = function(_, opts)
			require("conform").setup({
				formatters = {
					prettierd = {
						args = {
							"--config",
							vim.fn.expand("~/.config/nvim/lua/config/prettiercfg.json"),
						},
					},
				},
				formatters_by_ft = {
					lua = { "stylua" },
					cs = { "csharpier" },
					java = { "google-java-format" },
					python = { "black" },
					-- razor = { "injected", lsp_format = "never" },
					html = {"htmlbeautifier"},
					-- xml = {"prettier", "prettierd"},
					javascript = { "js_beautify" },
					typescript = { "prettierd" },
					json = { "prettierd" },
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
	{
		"zapling/mason-conform.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"stevearc/conform.nvim",
		},
		config = function(_, opts)
			require("mason-conform").setup({})
		end,
	},
}
