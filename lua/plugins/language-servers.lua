return {
  {
    "neovim/nvim-lspconfig",
  },
  {
    "saecki/crates.nvim",
    tag = 'stable',
    config = function()
      require('crates').setup()
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = '^5',
    lazy = false,
  },
  {
    'seblj/roslyn.nvim',
    ft = { 'cs', 'razor' },
    dependencies = {
      {
        -- By loading as a dependencies, we ensure that we are available to set
        -- the handlers for roslyn
        'tris203/rzls.nvim',
        config = function()
          ---@diagnostic disable-next-line: missing-fields
          require('rzls').setup {
            config = {
              on_attach = function(client, bufnr)
                require('workspace-diagnostics').populate_workspace_diagnostics(client, bufnr)
              end,
              filetypes = { 'razor' },
            },
          }
        end,
      },
    },
    config = function()
      require('roslyn').setup {
        filewatching = true,
        args = {
          '--stdio',
          '--logLevel=Information',
          '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
          '--razorSourceGenerator='
          .. vim.fs.joinpath(vim.fn.stdpath 'data' --[[@as string]], 'mason', 'packages', 'roslyn', 'libexec', 'Microsoft.CodeAnalysis.Razor.Compiler.dll'),
          '--razorDesignTimePath=' .. vim.fs.joinpath(
            vim.fn.stdpath 'data' --[[@as string]],
            'mason',
            'packages',
            'rzls',
            'libexec',
            'Targets',
            'Microsoft.NET.Sdk.Razor.DesignTime.targets'
          ),
        },
        ---@diagnostic disable-next-line: missing-fields
        config = {
          on_attach = function(client, bufnr)
            require('workspace-diagnostics').populate_workspace_diagnostics(client, bufnr)
          end,
          filetypes = { 'cs' },
          handlers = require 'rzls.roslyn_handlers',
          settings = {
            -- ['csharp|inlay_hints'] = {
            --   csharp_enable_inlay_hints_for_implicit_object_creation = true,
            --   csharp_enable_inlay_hints_for_implicit_variable_types = true,
            --
            --   csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            --   csharp_enable_inlay_hints_for_types = true,
            --   dotnet_enable_inlay_hints_for_indexer_parameters = true,
            --   dotnet_enable_inlay_hints_for_literal_parameters = true,
            --   dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            --   dotnet_enable_inlay_hints_for_other_parameters = true,
            --   dotnet_enable_inlay_hints_for_parameters = true,
            --   dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            --   dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            --   dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            -- },
            ['csharp|code_lens'] = {
              dotnet_enable_references_code_lens = true,
            },
            ['csharp|completion'] = {
              dotnet_show_name_completion_suggestions = true,
              dotnet_show_completion_items_from_unimported_namespaces = true,
            },
            ['csharp|background_analysis'] = {
              background_analysis = {
                dotnet_analyzer_diagnostics_scope = 'fullSolution',
                dotnet_compiler_diagnostics_scope = 'fullSolution',
              },
            },
          },
        },
      }

      vim.keymap.set("n", "<leader>cr", function()
        local clients = vim.lsp.get_clients()
        for _, value in ipairs(clients) do
          if value.name == "roslyn" then
            vim.notify("roslyn client found")
            value.rpc.request("workspace/diagnostic", { previousResultIds = {} }, function(err, result)
              if err ~= nil then
                print(vim.inspect(err))
              end
              if result ~= nil then
                print(vim.inspect(result))
              end
            end)
          end
        end
      end, { noremap = true, silent = true })
    end,
    init = function()
      -- we add the razor filetypes before the plugin loads
      vim.filetype.add {
        extension = {
          razor = 'razor',
          cshtml = 'razor',
        },
      }
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    version = "1.x",
    dependencies = {
      { "williamboman/mason.nvim", version = "1.x"},
      "neovim/nvim-lspconfig",
    },
    config = function(_, opts)
      require("mason-lspconfig").setup()
      require("mason-lspconfig").setup_handlers({
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          if server_name == "jdtls" then
            return true
          end
          if server_name == "rust_analyzer" then
            return true
          end
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              require('workspace-diagnostics').populate_workspace_diagnostics(client, bufnr)
            end,
          })
        end,
        -- ["textDocument/definition"] = function(...)
        -- 	return require("csharpls_extended").handler(...)
        -- end,
        -- ["jdtls"] = function ()
        -- do nothing
        -- end
        -- Next, you can provide a dedicated handler for specific servers.
        -- For example, a handler override for the `rust_analyzer`:
        --     ["rust_analyzer"] = function ()
        --         require("rust-tools").setup {}
        --     end
      })
    end,
  },
  {
    "artemave/workspace-diagnostics.nvim",
  },
}
