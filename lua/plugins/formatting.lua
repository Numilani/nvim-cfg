return {
	{
		"stevearc/conform.nvim",
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
