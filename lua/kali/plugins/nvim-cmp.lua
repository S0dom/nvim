return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer", -- source for text in buffer
        "hrsh7th/cmp-path",   -- source for file system paths
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "saadparwaiz1/cmp_luasnip", -- for autocompletion
        {
            "saecki/crates.nvim",
            event = { "BufRead Cargo.toml" },
            config = true,
        },
        -- "rcarriga/cmp-dap",
        "onsails/lspkind.nvim",
    },
    config = function()
        local cmp = require("cmp")

        local luasnip = require("luasnip")

        local lspkind = require("lspkind")

        cmp.setup({
            completion = {
                completeopt = "menu,menueone,noselect" --preview,noselect",
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            formatting = {
                format = lspkind.cmp_format {
                    with_text = true,
                    menu = {
                        buffer = "[BUF]",
                        nvim_lsp = "[LSP]",
                        nvim_lua = "[API]",
                        path = "[PATH]",
                        luasnip = "[SNIP]",
                    }
                }
            },
            mapping = cmp.mapping.preset.insert({
                ["<TAB>"] = cmp.mapping.select_next_item(),
                ["<S-TAB>"] = cmp.mapping.select_prev_item(),
                ["<C-k>"] = cmp.mapping.scroll_docs(-4),
                ["<C-j>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping({
                    i = function()
                        if cmp.visible() then
                            cmp.abort()
                        else
                            cmp.complete()
                        end
                    end,
                    c = function()
                        if cmp.visible() then
                            cmp.close()
                        else
                            cmp.complete()
                        end
                    end,
                }), -- Toggle Completion Window
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
            }),
            -- sources for autocompletion
            sources = cmp.config.sources({
                { name = "nvim_lua" },                     -- nvim integration
                { name = "crates" },
                { name = "nvim_lsp", keyword_length = 1 }, -- LSP
                { name = "luasnip",  keyword_length = 1 }, -- snippets
                { name = "buffer",   keyword_length = 3 }, -- text within current buffer
                { name = "path" },                         -- file system paths
            }),
            experimental = {
                ghost_text = true, -- this feature conflict with copilot.vim's preview.
            },
            sorting = {
                comparators = {
                    require("clangd_extensions.cmp_scores"),
                }
            }
        })
    end
}
