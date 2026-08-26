return {
	-- {
	--   "Piotr1215/pairup.nvim",
	--   cmd = {"Pairup"},
	--   config = function()
	--     require('pairup').setup()
	--   end,
	-- }
	-- {
	--     "zbirenbaum/copilot.lua"
	-- }
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {},
	},
	-- {
	--     "olimorris/codecompanion.nvim",
	--     version = "^19.0.0",
	--     opts = {},
	--     dependencies = {
	--         "nvim-lua/plenary.nvim",
	--         "nvim-treesitter/nvim-treesitter",
	--         "zbirenbaum/copilot.lua"
	--     },
	--     setup = function()
	--         requre('codecompanion').setup({
	--             interactions = {
	--                 chat = {
	--                     adapter = "copilot",
	--                 },
	--                 inline = {
	--                     adapter = "copilot",
	--                 },
	--             },
	--             adapters = {
	--                 http = {
	--                     copilot = function()
	--                         return require('codecompanion.adapters').extend("copilot", {
	--                         })
	--                     end
	--                 }
	--             }
	--         })
	--     end
	-- }
}
