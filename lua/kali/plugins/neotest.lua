return {
    "nvim-neotest/neotest",
    dependencies = {
        "rouge8/neotest-rust",
        "nvim-neotest/neotest-vim-test",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim"
    },
    config = function()
        require("neotest").setup({
            adapters = {
                -- require("neotest-vim-test"),
                require("neotest-rust")
            }
        })
    end
}
