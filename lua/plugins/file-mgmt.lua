return {
	-- neo-tree provides a better file browser, when needed
	{
		"nvim-neo-tree/neo-tree.nvim",
		lazy = false,
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "<F2>", "<cmd>Neotree toggle=true<CR>", desc = "Toggle filetree" },
		},
		opts = {
			sources = { "filesystem", "buffers", "git_status" },
			open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
			filesystem = {
				respect_gitignore = false,
				git_status_async = true,
				group_empty_dirs = true,
				bind_to_cwd = false,
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
				filtered_items = {
					visible = false,
					hide_dotfiles = false,
					hide_gitignored = true,
				},
			},
			window = {
				width = 60,
				mappings = {
					["l"] = "open",
					["h"] = "close_node",
					["<space>"] = "none",
					["Y"] = {
						function(state)
							local node = state.tree:get_node()
							local path = node:get_id()
							vim.fn.setreg("+", path, "c")
						end,
						desc = "Copy Path to Clipboard",
					},
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				git_status = {
					symbols = {
						unstaged = "󰄱",
						staged = "󰱒",
					},
				},
			},
		},
		config = function(_, opts)
			local function on_move(data)
				Snacks.rename.on_rename_file(data.source, data.destination)
			end

			local events = require("neo-tree.events")
			opts.event_handlers = opts.event_handlers or {}
			vim.list_extend(opts.event_handlers, {
				{ event = events.FILE_MOVED, handler = on_move },
				{ event = events.FILE_RENAMED, handler = on_move },
			})
			require("neo-tree").setup(opts)
			vim.api.nvim_create_autocmd("TermClose", {
				pattern = "*lazygit",
				callback = function()
					if package.loaded["neo-tree.sources.git_status"] then
						require("neo-tree.sources.git_status").refresh()
					end
				end,
			})
		end,
	},
	-- telescope provides a quick picker for a good number of list-driven elements,
	-- usually related to LSP information or search results.
	{
		"nvim-telescope/telescope.nvim",
		lazy = false,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-telescope/telescope-dap.nvim" },
		},
		keys = {
			{ "<leader>ff", ':lua require"telescope.builtin".buffers()<CR>', desc = "Find open buffer" },
			{ "<leader>fg", ':lua require"telescope.builtin".live_grep()<CR>', desc = "Find Everywhere" },
			{ "<leader>fF", ":lua require'telescope.builtin'.find_files()<CR>", desc = "Find Files" },
			{ "<leader>fc", ":lua require'telescope.builtin'.git_status()<CR>", desc = "Find Changed Files" },
			{
				"<leader>fy",
				'"zy<Cmd>lua require("telescope.builtin").grep_string({ search = vim.fn.getreg("z") })<CR>',
				mode = "x",
				silent = true,
				desc = "find selection",
			},
			{ "<leader>gu", ":lua require'telescope.builtin'.lsp_references()<CR>", desc = "Goto Usages" },
			{ "<leader>d?", ":lua require'telescope'.extensions.dap.commands()<CR>", desc = "See Debug Cmds" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					layout_strategy = "vertical",
					layout_config = {
						vertical = { width = 0.9 },
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			require("telescope").load_extension("ui-select")
			require("telescope").load_extension("dap")
		end,
	},
	-- template.nvim lets you define file templates that can be inserted via command.
	-- it supports placeholders ranging from simple to full-on lua expressions.
	-- more info here: https://github.com/nvimdev/template.nvim
	--
	-- for automating templates based on filename, see the example in tweaks.lua
	{
		"glepnir/template.nvim",
		dependencies = { { "nvim-telescope/telescope.nvim" } },
		cmd = { "Template", "TemProject" },
		config = function()
			require("template").setup({
				temp_dir = "~/.config/nvim/template",
			})
			require("telescope").load_extension("find_template")
		end,
	},
}
