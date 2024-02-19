return {
    "nvim-neotest/neotest",
    dependencies = {
        "rouge8/neotest-rust",
        "nvim-neotest/neotest-vim-test",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-neotest/neotest-python",
        "nvim-neotest/neotest-go",
        "Issafalcon/neotest-dotnet",
        {
            "vim-test/vim-test",
            opts = {
                setup = {}
            },
            config = function(plugin, opts)
                vim.g["test#strategy"] = "neovim"
                vim.g["test#neovim#term_position"] = "belowright"
                vim.g["test#neovim#preserve_screen"] = 1

                for k, _ in pairs(opts.setup) do
                    opts.setup[k](plugin, opts)
                end
            end,
        },
        "sidlatau/neotest-dart",
    },
    keys = {
        {
            "<leader>ltF",
            "<cmd>w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
            desc =
            "Debug File"
        },
        {
            "<leader>ltL",
            "<cmd>w|lua require('neotest').run.run_last({strategy = 'dap'})<cr>",
            desc =
            "Debug Last"
        },
        {
            "<leader>lta",
            "<cmd>w|lua require('neotest').run.attach()<cr>",
            desc =
            "Attach"
        },
        {
            "<leader>ltf",
            "<cmd>w|lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
            desc =
            "File"
        },
        {
            "<leader>ltl",
            "<cmd>w|lua require('neotest').run.run_last()<cr>",
            desc =
            "Last"
        },
        {
            "<leader>ltn",
            "<cmd>w|lua require('neotest').run.run()<cr>",
            desc =
            "Nearest"
        },
        {
            "<leader>ltN",
            "<cmd>w|lua require('neotest').run.run({strategy = 'dap'})<cr>",
            desc =
            "Debug Nearest"
        },
        {
            "<leader>lto",
            "<cmd>w|lua require('neotest').output.open({ enter = true })<cr>",
            desc =
            "Output"
        },
        {
            "<leader>lts",
            "<cmd>w|lua require('neotest').run.stop()<cr>",
            desc =
            "Stop"
        },
        {
            "<leader>ltS",
            "<cmd>w|lua require('neotest').summary.toggle()<cr>",
            desc =
            "Summary"
        },
    },
    opts = function()
        return {
            adapters = {
                require("neotest-vim-test") {
                    -- ignore_file_types = { "python", "vim", "lua" },
                },
                require("neotest-rust"),
                require("neotest-python")({
                    dap = {
                        justMyCode = false,
                        console = "integratedTerminal",
                    },
                    args = { "--log-level", "DEBUG", "--quiet" },
                    runner = "pytest",
                }),
                require("neotest-go"),
                require("neotest-dotnet"),
                require("neotest-dart")({

                })
            }
        }
    end
}
