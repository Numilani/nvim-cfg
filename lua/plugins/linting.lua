return {
    {
        "mfussenegger/nvim-lint",
        config = function(_,opts)
            require("lint").linters_by_ft = {
                markdown = {"vale"},
                python = {"pylint"},
                html = {"htmlhint"},
            }
        end
    },
    {
        "rshkarin/mason-nvim-lint",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-lint"
        },
        config = function(_,opts)
            require("mason-nvim-lint").setup({})
        end
    }
}
