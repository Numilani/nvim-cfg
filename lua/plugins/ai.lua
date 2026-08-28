return {
	{
		"olimorris/codecompanion.nvim",
		version = "^19.0.0",
		opts = {},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"zbirenbaum/copilot.lua", -- this is what handles auth instead of declaring a token in the adapters section; comment out if not using copilot
		},
		opts = {
			interactions = {
				chat = {
					adapter = "copilot", -- toggle to "claude_code" for claude
				},
				inline = {
					adapter = "copilot", -- toggle to "anthropic" for claude
				},
				cli = {
					agent = "copilot",
					agents = {
						copilot = {
							cmd = "copilot",
							args = {},
							description = "GitHub Copilot CLI",
							provider = "terminal",
						},
						-- claude_code = {
						-- 	cmd = "claude",
						-- 	args = {},
						-- 	description = "Claude Code CLI",
						-- 	provider = "terminal",
						-- },
					},
				},
			},
			adapters = {
				http = {
					copilot = function()
						return require("codecompanion.adapters").extend("copilot", {
							schema = {
								model = {
									default = "auto",
								},
							},
						})
					end,
					-- anthropic = function()
					-- 	return require("codecompanion.adapters").extend("anthropic", {
					-- 		env = {
					-- 			api_key = "ANTHROPIC_API_KEY", -- if your key is already stored in a default ENV variable, comment this out!
					-- 		},
					-- 		schema = {
					-- 			model = { default = "claude-sonnet-4-5" },
					-- 			extended_thinking = { default = false },
					-- 		},
					-- 		opts = {
					-- 			compaction = true,
					-- 		},
					-- 	})
					-- end,
				},
				acp = {
					copilot_acp = function()
						return require("codecompanion.adapters").extend("copilot_acp", {})
					end,
					-- claude_code = function()
					-- 	return require("codecompanion.adapters").extend("claude_code", {
					-- 		env = {
					-- 			CLAUDE_CODE_OAUTH_TOKEN = "CLAUDE_CODE_OAUTH_TOKEN",
					-- 			-- ANTHROPIC_API_KEY = "ANTHROPIC_API_KEY"
					-- 		},
					-- 		defaults = {
					-- 			mcpServers = "inherit_from_config",
					-- 			session_config_options = {
					-- 				model = function(_)
					-- 					return "claude-sonnet-4-5"
					-- 				end,
					-- 			},
					-- 		},
					-- 	})
					-- end,
				},
			},
		},
	},
}
