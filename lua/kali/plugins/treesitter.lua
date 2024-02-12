return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        {
            "nvim-treesitter/nvim-treesitter-context",
            config = function()
                require 'treesitter-context'.setup {
                    enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
                    max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
                    min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                    line_numbers = true,
                    multiline_threshold = 20, -- Maximum number of lines to show for a single context
                    trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                    mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
                    -- Separator between context and content. Should be a single character string, like '-'.
                    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                    separator = nil,
                    zindex = 20,     -- The Z-index of the context window
                    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
                }
            end
        },
        {
            "nvim-treesitter/playground",
        },
        {
            "nvim-treesitter/nvim-tree-docs",
        },
        {
            "windwp/nvim-ts-autotag",
            config = function()
                require('nvim-ts-autotag').setup()
            end
        },
    },
    opts = function()
        return {
            ensure_installed = "all",
            sync_install = false,
            highlight = {
                enable = true,
            },
            indent = { enable = true },
            -- Autotag Config
            autotag = {
                enable = true,
            },
            -- Playground Config
            playground = {
                enable = true,
                disable = {},
                updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = false, -- Whether the query persists across vim sessions
                keybindings = {
                    toggle_query_editor = 'o',
                    toggle_hl_groups = 'i',
                    toggle_injected_languages = 't',
                    toggle_anonymous_nodes = 'a',
                    toggle_language_display = 'I',
                    focus_language = 'f',
                    unfocus_language = 'F',
                    update = 'R',
                    goto_node = '<cr>',
                    show_help = '?',
                },
            },
            tree_docs = {
                enable = false,
            },
            auto_install = true,
        }
    end
}
