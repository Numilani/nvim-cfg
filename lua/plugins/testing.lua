return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"marilari88/neotest-vitest",
			"Nsidorenco/neotest-vstest",
			"nvim-neotest/neotest-python",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-vitest"),
					require("neotest-vstest"),
					require("neotest-python"),
				},
			})
		end,
	},
	-- Python adapter
	{
		"nvim-neotest/neotest-python",
		ft = { "python" },
	},

	-- Java adapter + deps
	{
		"rcasia/neotest-java",
		ft = { "java" },
		dependencies = {
			"nvim-java/nvim-java",
			-- "mfussenegger/nvim-jdtls",
			"mfussenegger/nvim-dap",

			"rcarriga/nvim-dap-ui",
		},
	},

	-- VSTest adapter (nsidorenko)
	{
		"Nsidorenco/neotest-vstest",
		ft = { "cs" },
	},
	{
		"marilari88/neotest-vitest",
		ft = { "js", "ts", "jsx", "tsx", "javascriptreact", "typescriptreact" },
	},
}
