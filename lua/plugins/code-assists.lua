return {
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "v1.*",
    opts = {
      keymap = {
        preset = "super-tab",
      },
      completion = {
        menu = {
          draw = {
            columns = {
              {"label", "label_description", gap = 1},
              {"kind_icon", "kind"},
            },
          },
          auto_show = true,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      fuzzy = {
        sorts = {
          'score',
          'sort_text',
          'kind'
        }
      },
      signature = {
        enabled = true,
      },
    },
    opts_extend = {
      "sources.completion.enabled_providers"
    },
  },
  {
    'dgagn/diagflow.nvim',
    config = function()
      require('diagflow').setup()
    end
  },
  {
    "stevearc/overseer.nvim",
    config = function()
      require('overseer').setup()
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {
      win = {
        size = 0.5,
      }
    }, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>cD",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Workspace Diagnostics",
      },
      {
        "<leader>cd",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Class Symbols",
      },
      {
        "<leader>cu",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "Find Usages...",
      },
      {
        "<leader>cl",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "LocList",
      },
      {
        "<leader>cq",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "QFList",
      },
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim"
  },
}
