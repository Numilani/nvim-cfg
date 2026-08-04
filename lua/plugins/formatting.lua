return {
	{
		"stevearc/conform.nvim",
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
					-- cs = { "csharpier" },
					java = { "google-java-format" },
					python = { "black" },
					html = { "htmlbeautifier" },
					javascript = { "prettier", lsp_format = "never" },
					javascriptreact = { "prettier", lsp_format = "never" },
					typescript = { "prettier", lsp_format = "never" },
					typescriptreact = { "prettier", lsp_format = "never" },
					json = { "prettier" },
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
