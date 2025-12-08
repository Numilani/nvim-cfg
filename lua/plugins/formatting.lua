return {
  {
    "stevearc/conform.nvim",
    keys = { {
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "Format Code",
    } },
    config = function(_, opts)
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          cs = { "clang-format" },
          java = { "google-java-format" },
          python = { "blue" },
          -- razor = { "injected", lsp_format = "never" },
          -- html = {"htmlbeautifier"},
          html = { "prettier", "prettierd" },
          javascript = { "js_beautify" },
          typescript = { "prettier", "prettierd" },
        },
        default_format_opts = {
          lsp_format = "prefer",
        },
      })
      require('conform').formatters.injected = {
        options = {
          ignore_errors = true,
          -- lang_to_formatters = {
          --   c_sharp = { "clang-format" },
          --   html = { "prettier" }
          -- }
        }
      }
    end,
  },
  {
    "zapling/mason-conform.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "stevearc/conform.nvim"
    },
    config = function(_, opts)
      require("mason-conform").setup({})
    end
  },
}
