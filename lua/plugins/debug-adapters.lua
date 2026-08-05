return {
	{
		"mfussenegger/nvim-dap",
		-- lazy = false,
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
            -- NOTE: got rid of launchsettings.json tweaks, they weren't working anyway.
            -- just edit the files and flag them for ignoring in git worktree
            -- (git update-index --skip-worktree <filename>)
			
			local dap = require("dap")
            --
			--    ADAPTER SETTINGS
			--

			dap.adapters.python = {
				type = "executable",
				command = vim.fn.exepath("debugpy-adapter"),
			}
			dap.adapters.coreclr = {
				type = "executable",
				command = vim.fn.exepath("netcoredbg"),
				args = { "--interpreter=vscode" },
				options = {
					detached = false,
				},
			}

			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = {
						vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
						"${port}",
					},
				},
			}

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.exepath("codelldb"),
					args = { "--port", "${port}" },
				},
			}

			--
			--    CONFIGURATIONS
			--

			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch File",
					program = "${file}",
					pythonPath = venv_path
							and ((vim.fn.has("win32") == 1 and venv_path .. "/Scripts/python") or venv_path .. "/usr/bin/python")
						or nil,
					console = "integratedTerminal",
				},
			}
			dap.configurations.java = {
				{
					type = "java",
					request = "attach",
					name = "Attach to Remote",
					hostName = "127.0.0.1",
					port = 5005,
					hotCodeReplace = "auto",
				},
			}
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
				},
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
				},
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
					env = {
						ASPNETCORE_ENVIRONMENT = "Development",
						ASPNETCORE_URLS = "<https://localhost:5001>;<http://localhost:5000>",
					},
					console = "integratedTerminal",
				},
			}
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		config = function()
			require("dap-python").setup("/usr/bin/python")
		end,
	},
	{
		"igorlfs/nvim-dap-view",
		lazy = false,
		sections = { "console", "watches", "breakpoints", "scopes", "exceptions", "threads", "repl" },
		default_section = "console",
		controls = {
			enabled = true,
		},
		auto_toggle = true,
	},
}
