return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "williamboman/mason.nvim",
      opts = { ensure_installed = { "java-debug-adapter", "java-test" } },
    },
    config = function()
      local dap = require("dap")
      dap.adapters.python = {
        type = "executable",
        command = vim.fn.exepath("debugpy-adapter"),
      }
      dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.exepath("netcoredbg"),
        args = { "--interpreter=vscode" },
      }
      dap.adapters.node2 = {
        type = 'executable',
        command = 'node',
        args = { os.getenv('HOME') .. '/.local/share/nvim/debug_adapters/vscode-node-debug2/out/src/nodeDebug.js' },
      }
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            os.getenv('HOME') .. "/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
            "${port}"
          },
        }
      }
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.exepath("codelldb"),
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch File",
          program = "${file}",
          pythonPath = venv_path
              and ((vim.fn.has("win32") == 1 and venv_path .. "/Scripts/python") or venv_path .. "/bin/python")
              or nil,
          console = "integratedTerminal",
        },
      }
      -- dap.configurations.java = {
      -- 	{
      -- 		type = "java",
      -- 		request = "attach",
      -- 		name = "Attach to Remote",
      -- 		hostName = "127.0.0.1",
      -- 		port = 5005,
      -- 	},
      -- 	{
      -- 		type = "java",
      -- 		request = "launch",
      -- 		name = "Launch Project",
      -- 		-- mainClass = function() return vim.fn.input("Main Class: ", mainClass) end
      -- 		classPaths = {}, -- jdtls should auto-populate
      -- 		modulePaths = {}, -- jdtls should auto-populate
      -- 	},
      -- }
      -- dap.configurations.javascript = {
      --   {
      --     type = "node2",
      --     request = "launch",
      --     name = "Launch File",
      --     program = "${file}",
      --     cwd = "${workspaceFolder}",
      --   },
      -- }
      -- dap.configurations.typescript = {
      --   {
      --     type = "node2",
      --     request = "launch",
      --     name = "Launch File (tsx)",
      --     program = "${file}",
      --     runtimeArgs = { "-r", "ts-node/register" },
      --     args = { "--inspect", "${file}" },
      --     console = "integratedTerminal",
      --     -- runtimeArgs = {"--experimental-transform-types", "tsx"},
      --     -- runtimeExecutable = "tsx",
      --     cwd = "${workspaceFolder}",
      --   },
      -- }
      dap.configurations.javascript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Current File",
          program = "${file}",
          cwd = "${workspaceFolder}",
          runtimeExecutable = "node",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        }
      }
      dap.configurations.typescript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Current File",
          program = "${file}",
          cwd = "${workspaceFolder}",
          runtimeExecutable = "node",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        }
      }

      local function get_lldb_target()
        return coroutine.create(function(dap_run_co)
          local items = vim.fn.globpath(vim.fn.getcwd(), "**/*", 0, 1)
          local opts = {
            format_item = function(path)
              return vim.fn.fnamemodify(path, ":t")
            end,
          }
          local function cont(choice)
            if choice == nil then
              return nil
            else
              coroutine.resume(dap_run_co, choice)
            end
          end

          vim.ui.select(items, opts, cont)
        end)
      end

      dap.configurations.c = {
        {
          name = "Launch",
          request = "launch",
          type = "codelldb",
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
          console = "integratedTerminal",
          program = get_lldb_target,
        },
      }
      dap.configurations.rust = {
        {
          name = "Launch",
          request = "launch",
          type = "codelldb",
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
          console = "integratedTerminal",
          program = get_lldb_target,
        },
      }

      local function get_dll()
        return coroutine.create(function(dap_run_co)
          local items = vim.fn.globpath(vim.fn.getcwd(), "**/bin/Debug/**/*.dll", 0, 1)
          local opts = {
            format_item = function(path)
              return vim.fn.fnamemodify(path, ":t")
            end,
          }
          local function cont(choice)
            if choice == nil then
              return nil
            else
              coroutine.resume(dap_run_co, choice)
            end
          end

          vim.ui.select(items, opts, cont)
        end)
      end

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = get_dll,
        },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("dapui").setup({
        layouts = {
          {
            elements = {
              {
                id = "scopes",
                size = 0.33,
              },
              {
                id = "console",
                size = 0.34,
              },
              {
                id = "watches",
                size = 0.33,
              },
            },
            position = "bottom",
            size = 10
          },
        },
      })
    end,
  },
  -- {
  -- 	"jay-babu/mason-nvim-dap.nvim",
  -- 	dependencies = {
  -- 		"williamboman/mason.nvim",
  -- 	},
  -- 	config = function()
  -- 		require("mason-nvim-dap").setup({
  -- 			handlers = {
  -- 				function(config)
  -- 					require("mason-nvim-dap").default_setup(config)
  -- 				end,
  -- 				node2 = function(config)
  -- 					config.adapters = {
  -- 						type = "executable",
  -- 						command = vim.fn.exepath("node-debug2-adapter"),
  -- 						args = { "--experimental-transform-types" },
  -- 					}
  -- 					require("mason-nvim-dap").default_setup(config)
  -- 				end,
  -- 			},
  -- 		})
  -- 	end,
  -- },
}
