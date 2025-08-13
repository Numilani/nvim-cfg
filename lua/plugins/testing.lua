return {
  -- Neotest core (no adapters here)
  {
    "nvim-neotest/neotest",
    ft = { "python", "java", "cs" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
    },
    config = function()
      local function setup_neotest_for_ft(ft)

        local adapters = {}

        if ft == "python" then
          adapters[#adapters+1] = require("neotest-python")({
            dap = { justMyCode = false },
          })
        elseif ft == "java" then
          adapters[#adapters+1] = require("neotest-java")()
        elseif ft == "cs" then
          adapters[#adapters+1] = require("neotest-vstest")()
        end

        require("neotest").setup({ adapters = adapters })
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "python", "java", "cs" },
        callback = function(args)
          setup_neotest_for_ft(args.match)
        end,
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

      "mfussenegger/nvim-jdtls",
      "mfussenegger/nvim-dap",

      "rcarriga/nvim-dap-ui",
    },
  },

  -- VSTest adapter (nsidorenko)
  {
    "nsidorenko/neotest-vstest",
    ft = { "cs" },
  },
}

