--
-- L S P   A N D   D I A G N O S T I C S
--

-- handle treesitter vs lsp folding

vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client:supports_method("textDocument/foldingRange") then
			vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end,
})

-- disable underlines for info/hints
vim.diagnostic.config({
	virtual_text = false,
	underline = {
		severity = {
			min = vim.diagnostic.severity.WARN,
		},
	},
})

-- configure LSPs
vim.lsp.config("html", {
	filetypes = { "html", "razor" },
})

-- enable LSPs

vim.lsp.enable("html")
vim.lsp.enable("jsonls")
vim.lsp.enable("marksman")

-- vim.lsp.enable('roslyn_ls')

vim.lsp.enable("stylua")
vim.lsp.enable("ts_ls")


