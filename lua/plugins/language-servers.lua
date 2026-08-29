return {
	-- lspconfig doesn't actually *add* LSPs, but it handles some automatic settings.
	{
		"neovim/nvim-lspconfig",
		lazy = false,
	},
	-- mason-tool-installer is purely for auto-installing tools on first launch
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
		"seblyng/roslyn.nvim",
		opts = function()
			local options = {}
			if vim.g.is_windows then
				options.filewatching = "roslyn"
			end
			return options
		end,
		config = function()
			local cfg = {}
			if vim.g.is_windows then
				cfg.handlers = {
					["textDocument/diagnostic"] = function(err, result, ctx)
						local req_id = ctx.params and ctx.params.identifier
						if not req_id then
							return
						end
						return vim.lsp.diagnostic.on_diagnostic(err, result, ctx)
					end,
				}
			end
			return cfg
		end,
	},
}
