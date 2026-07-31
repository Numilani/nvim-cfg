return {
	{
		"mfussenegger/nvim-dap",
		-- lazy = false,
		dependencies = {
			"williamboman/mason.nvim",
			opts = { ensure_installed = { "java-debug-adapter", "java-test" } },
		},
		config = function()
			local dap = require("dap")
			-- dap.set_log_level("TRACE")

			dap.listeners.on_config["launchsettings-merge"] = function(config)
				if config.type ~= "coreclr" and config.type ~= "netcoredbg" then
					return config
				end
        if not config.env or not config.env.ASPNETCORE_HTTP_PORT then
          return config
        end

        local merged = vim.deepcopy(config)
        local port = merged.env.ASPNETCORE_HTTP_PORT
        merged.env.ASPNETCORE_URLS = "https://localhost:" .. port
        return merged
        
			end

			-- Reusable function to fix the env nesting dynamically
			local function fix_env_nesting(adapter_name)
				dap.adapters[adapter_name] = vim.tbl_deep_extend("force", dap.adapters[adapter_name] or {}, {
					enrich_config = function(config, on_config)
						if config.env then
							config.options = config.options or {}
							config.options.env = vim.tbl_deep_extend("force", config.options.env or {}, config.env)
						end
						on_config(config)
					end,
				})
			end

			local adapters_to_fix = { "coreclr", "python", "node2" }

			for _, adapter in ipairs(adapters_to_fix) do
				fix_env_nesting(adapter)
			end

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
				type = "executable",
				command = "node",
				args = {
					os.getenv("HOME") .. "/.local/share/nvim/debug_adapters/vscode-node-debug2/out/src/nodeDebug.js",
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
