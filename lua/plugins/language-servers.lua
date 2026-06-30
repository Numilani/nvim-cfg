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
	-- {
	-- 	"nvim-java/nvim-java",
	-- 	config = function()
	-- 		require("java").setup()
	-- 		vim.lsp.enable("jdtls")
	-- 	end,
	-- },
  {
    "seblyng/roslyn.nvim"
  },
	-- {
	-- 	"seblyng/roslyn.nvim",
	--    lazy = false,
	-- 	-- opts = {
	-- 	--     filewatching = "auto",
	-- 	--     config = {
	-- 	--       capabilities = capabilities,
	-- 	--     }
	-- 	--   },
	-- 	config = function()
	-- 		vim.lsp.config("roslyn", {
	--        capabilities = {
	--          workspace = {
	--            didChangeWatchedFiles = {
	--              dynamicRegistration = true
	--            },
	--          },
	--        },
	-- 			settings = {
	-- 				["csharp|inlay_hints"] = {
	-- 					csharp_enable_inlay_hints_for_implicit_object_creation = true,
	-- 					csharp_enable_inlay_hints_for_implicit_variable_types = true,
	--
	-- 					csharp_enable_inlay_hints_for_lambda_parameter_types = true,
	-- 					csharp_enable_inlay_hints_for_types = true,
	-- 					dotnet_enable_inlay_hints_for_indexer_parameters = true,
	-- 					dotnet_enable_inlay_hints_for_literal_parameters = true,
	-- 					dotnet_enable_inlay_hints_for_object_creation_parameters = true,
	-- 					dotnet_enable_inlay_hints_for_other_parameters = true,
	-- 					dotnet_enable_inlay_hints_for_parameters = true,
	-- 					dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
	-- 					dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
	-- 					dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
	-- 				},
	-- 				["csharp|code_lens"] = {
	-- 					dotnet_enable_references_code_lens = true,
	-- 				},
	-- 				["csharp|completion"] = {
	-- 					dotnet_show_name_completion_suggestions = true,
	-- 					dotnet_show_completion_items_from_unimported_namespaces = true,
	-- 				},
	-- 				["csharp|background_analysis"] = {
	-- 					background_analysis = {
	-- 						dotnet_analyzer_diagnostics_scope = "fullSolution",
	-- 						dotnet_compiler_diagnostics_scope = "fullSolution",
	-- 					},
	-- 				},
	-- 			},
	-- 		})
	-- 		vim.lsp.enable("roslyn")
	-- 	end,
	-- 	init = function()
	-- 		-- We add the Razor file types before the plugin loads.
	-- 		vim.filetype.add({
	-- 			extension = {
	-- 				razor = "razor",
	-- 				cshtml = "razor",
	-- 			},
	-- 		})
	-- 	end,
	-- },
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function(_, opts)
			require("mason-lspconfig").setup({
				automatic_enable = {
					exclude = {
						"rust_analyzer",
						-- "jdtls",
					},
				},
			})
		end,
	},
	-- {
	-- 	"artemave/workspace-diagnostics.nvim",
	-- },
}
