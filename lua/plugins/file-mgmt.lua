return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        group_empty_dirs = true,
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
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
        { event = events.FILE_MOVED,   handler = on_move },
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
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "html", "javascript", "typescript", "tsx", "java", "c_sharp", "python" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable = true,
          enable_close = true,
          enable_rename = true,
          filetypes = {"html", "xml", "js", "jsx", "typescript", "ts", "tsx", "javascriptreact", "typescriptreact"}
        }
      })
    end,
  },
  -- {
  -- 	"ibhagwan/fzf-lua",
  -- 	dependencies = {
  -- 		"nvim-tree/nvim-web-devicons",
  -- 	},
  -- 	config = function()
  -- 		require("fzf-lua").setup({
  -- 			winopts = {
  -- 				preview = {
  -- 					vertical = "down:30%",
  -- 					layout = "vertical"
  -- 				}
  -- 			}
  -- 		})
  -- 		require("fzf-lua").register_ui_select()
  -- 	end,
  -- },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-telescope/telescope-dap.nvim'}
    },
    config = function()
      require('telescope').setup({
        defaults = {
          layout_strategy = 'vertical',
          layout_config = {
            vertical = { width = 0.9}
          }
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        }
      })
      require('telescope').load_extension("fzf")
      require('telescope').load_extension("ui-select")
      require('telescope').load_extension("dap")
    end
  },
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      require("grug-far").setup()
    end,
  },
  {
    "glepnir/template.nvim",
    dependencies = {{'nvim-telescope/telescope.nvim'}},
    cmd = { 'Template', 'TemProject' },
    config = function()
      require('template').setup({
        temp_dir = '~/.config/nvim/template'
      })
      require('telescope').load_extension('find_template')
    end
  }
}
