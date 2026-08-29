return {
	-- nvim-dap gets its own file because it requires so much custom configuration.
	-- DAP is a protocol with an extensive amount of information, but config tips
	-- specific to nvim-dap can be found here:
	-- https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
	{
		"mfussenegger/nvim-dap",
		-- lazy = false,
		dependencies = {
			"williamboman/mason.nvim",
		},
		keys = {
			{ "<F5>", "<cmd>DapContinue<CR>", desc = "(DBG) Start/Continue" },
			{ "<F6>", "<cmd>DapStepOut<CR>", desc = "(DBG) Step Out" },
			{ "<F7>", "<cmd>DapStepOver<CR>", desc = "(DBG) Step Over" },
			{ "<F8>", "<cmd>DapStepInto<CR>", desc = "(DBG) Step Into" },
			{ "<F9>", "<cmd>DapToggleBreakpoint<CR>", desc = "(DBG) Toggle Breakpoint" },
			{ "<F10>", "<cmd>DapViewToggle<CR>", desc = "(DBG) Toggle Debug UI" },
			{ "<F11>", "<cmd>lua require'dapui'.eval()<CR>", desc = "(DBG) Eval Cursor" },
		},
		config = function()
			local dap = require("dap")
			--
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
					console = "internalConsole",
				},
			}
		end,
	},
	-- some custom extensions have made setup a bit easier; python in particular
	-- can be a bit difficult, so I've added this to compensate. It's not required, tho.
	{
		"mfussenegger/nvim-dap-python",
		config = function()
			require("dap-python").setup("/usr/bin/python")
		end,
	},
	-- nvim-dap, in isolation, doesn't actually have a UI at all.
	-- nvim-dap-view adds one, though there's also nvim-dap-ui as an alternative.
	{
		"igorlfs/nvim-dap-view",
		lazy = false,
		opts = {
			winbar = {
				sections = { "console", "watches", "breakpoints", "scopes", "exceptions", "threads", "repl" },
				default_section = "console",
				controls = {
					enabled = true,
				},
			},
			auto_toggle = true,
		},
	},
}
