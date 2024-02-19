return {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    dependencies = {
        {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end
        },
        {
            "johnpapa/vscode-angular-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end
        }
    },

    build = "make install_jsregexp",
    config = function()
        local ls = require "luasnip"
        local types = require "luasnip.util.types"

        ls.config.set_config {
            -- This tells LuaSnip to remember to keep around the last snippet.
            -- You can jump back into it even if you move outside of the selection
            history = true,

            -- This one is cool cause if you have dynamic snippets, it updates as you type!
            updateevents = "TextChanged,TextChangedI",

            -- Autosnippets:
            enable_autosnippets = true,

            -- Crazy highlights!!
            -- #vid3
            -- ext_opts = nil,
            ext_opts = {
                [types.choiceNode] = {
                    active = {
                        virt_text = { { " « ", "NonTest" } },
                    },
                },
            },
        }

        -- <c-k> is my expansion key
        -- this will expand the current item or jump to the next item within the snippet.
        vim.keymap.set({ "i", "s" }, "<c-k>", function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, { silent = true, desc = "Jump to next section in snippet" })

        -- <c-j> is my jump backwards key.
        -- this always moves to the previous item within the snippet
        vim.keymap.set({ "i", "s" }, "<c-j>", function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { silent = true, desc = "Jump to previous section in snippet" })

        -- <c-l> is selecting within a list of options.
        -- This is useful for choice nodes (introduced in the forthcoming episode 2)
        vim.keymap.set("i", "<c-l>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end, { desc = "Expand snippet" })

        vim.keymap.set("i", "<c-u>", require "luasnip.extras.select_choice")
    end,
}
