return {
  -- tokyonight - color theme!
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = { style = "moon" },
	},
  {
    'bluz71/vim-moonfly-colors', name = "moonfly", lazy = false, priority = 1000
  },
  {
    'NLKNguyen/papercolor-theme', lazy = false, priority = 1000
  },
  {
    "tomasr/molokai", lazy = false, priority = 1000
  },
  -- todo-comments - highlight TODO, NOTE, and other annotations!
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup()
		end,
	},
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({})
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("lualine").setup({
        theme = "base16",
      })
    end
  },
  {
    "szw/vim-maximizer"
  },
  -- Noice - new UI design for infoboxes (use :noice instead of :messages)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify"
    },
    config = function()
      require("noice").setup({
        messages = {
          enabled = true,
          view = "mini",
          view_error = "notify",
          view_warn = "notify",
        },
        lsp = {
          progress = {
            enabled = true,
            format = "lsp_progress",
            format_done = "lsp_progress_done",
            throttle = 1000 / 30,
            view = "mini",
          },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      })
    end
  }
}
