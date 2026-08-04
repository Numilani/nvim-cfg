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
        end
}
