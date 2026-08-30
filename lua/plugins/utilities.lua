return {
	-- ts-textobjects adds more vim motions for quickly navigating and selecting
	-- text. Not all of these work with every language (it depends heavily on what
	-- the treesitter config for that lang supports), but those that do work, can
	-- really speed movement up a lot.
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		init = function()
			vim.g.no_plugin_maps = true
		end,
		keys = {
			{
				"af",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
				end,
				mode = { "x", "o" },
				desc = "Select outer function",
			},
			{
				"if",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
				end,
				mode = { "x", "o" },
				desc = "Select inner function",
			},
			{
				"ac",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
				end,
				mode = { "x", "o" },
				desc = "Select local scope",
			},
			-- added 4/30
			{
				"aa",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@local.definition.parameter",
						"locals"
					)
				end,
				mode = { "x", "o" },
				desc = "Select parameter",
			},
			-- movement motions (defaults)
			{
				"]f",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
				end,
				mode = { "n", "x", "o" },
				desc = "Goto next function start",
			},
			{
				"[f",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
				end,
				mode = { "n", "x", "o" },
				desc = "Goto previous function start",
			},
			{
				"]o",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start(
						{ "@loop.inner", "@loop.outer" },
						"textobjects"
					)
				end,
				mode = { "n", "x", "o" },
				desc = "Goto next loop start",
			},
			{
				"]c",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
				end,
				mode = { "n", "x", "o" },
				desc = "Goto next local scope start",
			},
			{
				"[c",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@local.scope", "locals")
				end,
				mode = { "n", "x", "o" },
				desc = "Goto previous local scope start",
			},
			-- added 4/30
			{
				"]?",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@keyword.conditional", "textobjects")
				end,
				mode = { "n", "x", "o" },
				desc = "Goto next conditional",
			},
		},
		opts = {
			select = {
				lookahead = true,
				selection_modes = {
					["@parameter.outer"] = "v",
					["@function.outer"] = "V",
				},
				include_surrounding_whitespace = false,
			},
			move = {
				set_jumps = true,
			},
		},
	},
	-- Flash - the new AceJump alternative, jump to locs on screen via letters
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>j",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "FlashJump",
			},
		},
	},
	-- Neogit is a git UI that integrates nicely into neovim (WIP TESTING)
	{
		"NeogitOrg/neogit",
		lazy = true,
		dependencies = {
			"sindrets/diffview.nvim",
			"m00qek/baleia.nvim",
			"nvim-telescope/telescope.nvim",
		},
		cmd = "Neogit",
	},
	-- overseer provides a task runner; compatible with VSCode's tasks.json/launch.json!
	{
		"stevearc/overseer.nvim",
		keys = {
			{ "<F4>", "<cmd>OverseerRun<CR>", desc = "Run Task..." },
			-- some terminals don't handle shift-Fkeys correctly, hence the double-entry
			{ "<F16>", "<cmd>OverseerToggle<CR>", desc = "Show Running Tasks" },
			{ "<S-F4>", "<cmd>OverseerToggle<CR>", desc = "Show Running Tasks" },
		},
	},
	{
		"stevearc/stickybuf.nvim",
		config = function()
			require("stickybuf").setup()
		end,
	},
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function(_, opts)
			require("mini.pairs").setup()
			require("mini.surround").setup()
			require("mini.cursorword").setup()
			require("mini.basics").setup()
			require("mini.bufremove").setup()
		end,
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			rename = { enabled = true },
		},
		config = true,
	},
	-- listish - handle quicklist/loclist more gracefully
	{
		"arsham/listish.nvim",
		dependencies = {
			"arsham/arshlib.nvim",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = {
			quickfix = {
				on_cursor = "<leader>qa",
			},
			loclist = {
				open = "<leader>lo",
				on_cursor = "<leader>la",
				add_note = "<leader>ln",
				clear = "<leader>ld",
				close = "<leader>lc",
				next = "]l",
				prev = "[l",
			},
		},
	},
	{
        "zongben/navimark.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim"
        },
        config = function()
            require('navimark').setup({
                keymap = {
                    base = {
                        mark_toggle = "",
                        mark_add = "ma",
                        mark_add_with_title = "mn",
                        mark_remove = "mx",
                        open_mark_picker = "mo",
                    },
                },
            })
        end
	},
	-- marks - clearer mark displays and handling
	-- {
	-- 	"chentoast/marks.nvim",
	-- 	event = "VeryLazy",
	-- 	opts = {},
	-- },
	-- adds mermaid diagram support (sort of? very WIP)
	{
		"kevalin/mermaid.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("mermaid").setup()
		end,
	},
	-- which-key helps with learning commands by showing a list of commands at the
	-- bottom of the screen when you press the leader key. To see more, try hitting
	-- backspace to look at non-leader keymaps!
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>??",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
		config = function()
			require("which-key").add({
				{ "<leader>?", group = "help" },
				{ "<leader>c", group = "code" },
				{ "<leader>g", group = "goto" },
				{ "<leader>f", group = "find" },
				{ "<leader>d", group = "debug" },
				{ "<leader>s", group = "surround" },
			})
		end,
	},
	-- fterm just allows you to open a terminal from within neovim. Not sure it's
	-- the best choice, but it's simple.
	{
		"numToStr/FTerm.nvim",
		keys = {
			{ "<F3>", "<cmd>lua require'FTerm'.toggle()<CR>", desc = "Toggle Terminal" },
			{ "<F3>", mode = { "t" }, "<cmd>lua require'FTerm'.toggle()<CR>", desc = "Toggle Terminal" },
		},
		config = function()
			local cfg = {}
			if vim.g.is_windows then
				require("FTerm").setup({
					cmd = "powershell",
				})
			end
		end,
	},
	-- If you feel like writing your leetcode puzzle solutions in neovim, you can!
	{
		"kawre/leetcode.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			lang = "python",
		},
	},
	-- shows git symbols in the side gutter
	{
		"lewis6991/gitsigns.nvim",
	},
	-- more gracefully handles macro recording
	{
		"chrisgrieser/nvim-recorder",
		dependencies = "rcarriga/nvim-notify",
		opts = {
			dynamicSlots = "rotate",
		},
	},
	-- renders markdown with nice colors and visuals
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		opts = {
			preview = {
				filetypes = { "markdown", "codecompanion" },
				ignore_buftypes = {},
			},
		},
	},
}
