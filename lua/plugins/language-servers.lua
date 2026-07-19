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
		"seblyng/roslyn.nvim",
		opts = {
			filewatching = "roslyn",
			config = {
				handlers = {
					["textDocument/diagnostic"] = function(err, result, ctx)
						local req_id = ctx.params and ctx.params.identifier
						if not req_id then
							return
						end
						return vim.lsp.diagnostic.on_diagnostic(err, result, ctx)
					end,
				},
			},
		},
	},
}
