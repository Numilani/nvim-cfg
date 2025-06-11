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
          require("neotest-python"),
          require("rustaceanvim.neotest"),
          require("neotest-vstest"),
          require("neotest-java")
        }
      })
    end
  }
}
