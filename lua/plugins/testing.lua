return {
  {
    "nvim-neotest/neotest-python"
  },
  {
    "nsidorenco/neotest-vstest"
  },
  {
    "rcasia/neotest-java",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui"
    }
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          function()
            if vim.bo.filetype == "java" then
              return require("neotest-java")
            end
          end,
          function()
            if vim.bo.filetype == "python" then
              return require("neotest-python")
            end
          end,
          function()
            if vim.bo.filetype == "rust" then
              return require("rustaceanvim.neotest")
            end
          end,
          require("neotest-vstest")
        }
      })
    end
  }
}
