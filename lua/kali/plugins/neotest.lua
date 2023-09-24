return {
    "nvim-neotest/neotest",
    dependencies = {
        "rouge8/neotest-rust",
        "nvim-neotest/neotest-vim-test",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "andy-bell101/neotest-java",
    },
    keys = {
        {
            "<leader>tF",
            "<cmd>w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
            desc =
            "Debug File"
        },
        {
            "<leader>tL",
            "<cmd>w|lua require('neotest').run.run_last({strategy = 'dap'})<cr>",
            desc =
            "Debug Last"
        },
        {
            "<leader>ta",
            "<cmd>w|lua require('neotest').run.attach()<cr>",
            desc =
            "Attach"
        },
        {
            "<leader>tf",
            "<cmd>w|lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
            desc =
            "File"
        },
        {
            "<leader>tl",
            "<cmd>w|lua require('neotest').run.run_last()<cr>",
            desc =
            "Last"
        },
        {
            "<leader>tn",
            "<cmd>w|lua require('neotest').run.run()<cr>",
            desc =
            "Nearest"
        },
        {
            "<leader>tN",
            "<cmd>w|lua require('neotest').run.run({strategy = 'dap'})<cr>",
            desc =
            "Debug Nearest"
        },
        {
            "<leader>to",
            "<cmd>w|lua require('neotest').output.open({ enter = true })<cr>",
            desc =
            "Output"
        },
        {
            "<leader>ts",
            "<cmd>w|lua require('neotest').run.stop()<cr>",
            desc =
            "Stop"
        },
        {
            "<leader>tS",
            "<cmd>w|lua require('neotest').summary.toggle()<cr>",
            desc =
            "Summary"
        },
    },
    config = function()
        require("neotest").setup({
            adapters = {
                -- require("neotest-vim-test"),
                require("neotest-rust"),
                require("neotest-java")
            }
        })
    end
}
