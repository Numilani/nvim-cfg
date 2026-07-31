return {
  -- Neotest core (no adapters here)
  -- {
  --   "nvim-neotest/neotest",
  --   ft = { "python", "java", "cs" },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "antoinemadec/FixCursorHold.nvim",
  --   },
  --   config = function()
  --     local function setup_neotest_for_ft(ft)
  --
  --       local adapters = {}
  --
  --       if ft == "python" then
  --         adapters[#adapters+1] = require("neotest-python")({
  --           dap = { justMyCode = false },
  --         })
  --       elseif ft == "java" then
  --         adapters[#adapters+1] = require("neotest-java")()
  --       elseif ft == "cs" then
  --         adapters[#adapters+1] = require("neotest-vstest")()
  --       elseif ft == "js" or ft == "ts" or ft == "jsx" or ft == "tsx" or ft == "javascriptreact" or ft == "typescriptreact" then
  --         adapters[#adapters+1] = require("neotest-vitest")()
  --       end
  --
  --       require("neotest").setup({ adapters = adapters })
  --     end
  --
  --     vim.api.nvim_create_autocmd("FileType", {
  --       pattern = { "python", "java", "cs", "js", "ts", "jsx", "tsx", "javascriptreact", "typescriptreact"},
  --       callback = function(args)
  --         setup_neotest_for_ft(args.match)
  --       end,
  --     })
  --   end,
  -- },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "marilari88/neotest-vitest",
      "Nsidorenco/neotest-vstest",
      "nvim-neotest/neotest-python"
    },
    config = function()
      require('neotest').setup({adapters = {
        require('neotest-vitest'),
        require('neotest-vstest'),
        require('neotest-python'),
      },
      })
    end,
  },
  -- Python adapter
  {
    "nvim-neotest/neotest-python",
    ft = { "python" },
  },

  -- Java adapter + deps
  {
    "rcasia/neotest-java",
    ft = { "java" },
    dependencies = {
      "nvim-java/nvim-java",
      -- "mfussenegger/nvim-jdtls",
      "mfussenegger/nvim-dap",

      "rcarriga/nvim-dap-ui",
    },
  },

  -- VSTest adapter (nsidorenko)
  {
    "Nsidorenco/neotest-vstest",
    ft = { "cs" },
  },
  {
    "marilari88/neotest-vitest",
    ft = { "js", "ts", "jsx", "tsx", "javascriptreact", "typescriptreact"}
  }
}

