return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.2",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
        { "nvim-telescope/telescope-fzf-native.nvim", build="make"},
    },
    config = function ()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                prompt_prefix = "   ",
                selection_caret = "  ",
                entry_prefix = "  ",
                initial_mode = "insert",
                selection_strategy = "reset",
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        results_width = 0.8,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                file_ignore_patterns = {},
                path_display = {"truncate"},
                winblend = 0,
                border = {},
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                color_devicons = true,
                set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
                mappings = {
                    i = {
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                    n = {
                        ["q"] = actions.close,
                    },
                },
                extensions = {
                    fzf = {
                      fuzzy = true,                    -- false will only do exact matching
                      override_generic_sorter = true,  -- override the generic sorter
                      override_file_sorter = true,     -- override the file sorter
                      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                                       -- the default case_mode is "smart_case"
                    },
                    notify = {

                    },
                }
            }
        })

        telescope.load_extension("fzf")
        telescope.load_extension("notify")

        local keymap = vim.keymap.set

        keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {desc = "Fuzzy find files in cwd"})
        keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", {desc = "Fuzzy find recent files"})
        keymap("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", {desc = "Find string in cwd"})
        keymap("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", {desc = "Find string under cursor in cwd"})
    end,
}
