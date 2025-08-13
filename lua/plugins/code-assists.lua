return {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "v0.11.0",
    opts_extend = {
      "sources.default",
    },
    opts = {
      keymap = {
        preset = "super-tab",
      },
      completion = {
        menu = {
          auto_show = false,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      signature = {
        enabled = false,
      },
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
      local overseer = require("overseer")
      local template_dir = vim.fn.stdpath("config") .. "/lua/overseer/template"

      -- Recursively find all Lua files
      local files = vim.fn.glob(template_dir .. "/**/*.lua", false, true)

      for _, file in ipairs(files) do
        local rel_path = file:sub(#template_dir + 2, -5) -- strip base dir + slash and ".lua"
        local mod_name = "overseer.template." .. rel_path:gsub("/", ".")


        local ok, template = pcall(require, mod_name)
        if ok and type(template) == "table" then
          overseer.register_template(template)
        else
          vim.notify("Failed to load Overseer template: " .. mod_name, vim.log.levels.ERROR)
        end
      end
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
        "<leader>cX",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "All Diagnostics (Trouble)",
      },
      {
        "<leader>cD",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cL",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>cL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>cQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    setup = function()
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
      for _, ls in ipairs(language_servers) do
        require("lspconfig")[ls].setup({
          capabilities = capabilities,
          -- you can add other fields for setting up lsp server in this table
        })
      end

      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end
      })
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    setup = function()
      require "lsp_signature".setup()
    end
  },
}
