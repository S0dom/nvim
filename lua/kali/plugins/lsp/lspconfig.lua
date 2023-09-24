return {
    {
        "folke/neodev.nvim",
        config = function()
            local neodev = require("neodev")
            neodev.setup({
                library = {
                    enabled = true,                    -- when not enabled, neodev will not change any settings to the LSP server
                    -- these settings will be used for your Neovim config directory
                    runtime = true,                    -- runtime path
                    types = true,                      -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
                    plugins = { "nvim-dap-ui", true }, -- installed opt or start plugins in packpath
                    -- you can also specify the list of plugins to make available as a workspace library
                    -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
                },
                setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
                -- for your Neovim config directory, the config.library settings will be used as is
                -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
                -- for any other directory, config.library.enabled will be set to false
                override = function(root_dir, options) end,
                -- With lspconfig, Neodev will automatically setup your lua-language-server
                -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
                -- in your lsp start options
                lspconfig = true,
                -- much faster, but needs a recent built of lua-language-server
                -- needs lua-language-server >= 3.6.0
                pathStrict = true,
            })
        end

    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            { "antosha417/nvim-lsp-file-operations", config = true },
        },
        config = function()
            local lspconfig = require("lspconfig")

            -- used to enable autocompletion (assign to every lsp server config)
            -- local capabilities = cmp_nvim_lsp.default_capabilities()
            local on_attach, capabilities = require("kali.share.utils")

            lspconfig["html"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            lspconfig["emmet_language_server"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte",
                    "pug", "typescriptreact", "vue" },
                init_options = {
                    --- @type table<string, any> https://docs.emmet.io/customization/preferences/
                    preferences = {},
                    --- @type "always" | "never" defaults to `"always"`
                    showexpandedabbreviation = "always",
                    --- @type boolean defaults to `true`
                    showabbreviationsuggestions = true,
                    --- @type boolean defaults to `false`
                    showsuggestionsassnippets = false,
                    --- @type table<string, any> https://docs.emmet.io/customization/syntax-profiles/
                    syntaxprofiles = {},
                    --- @type table<string, string> https://docs.emmet.io/customization/snippets/#variables
                    variables = {},
                    --- @type string[]
                    excludelanguages = {},
                },
            })

            lspconfig["cssls"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            lspconfig["tsserver"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            lspconfig["lua_ls"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
                on_init = function(client)
                    local path = client.workspace_folders[1].name
                    if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                        client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" },
                                },
                                -- Make the server aware of Neovim runtime files
                                workspace = {
                                    checkThirdParty = false,
                                    library = {
                                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                        [vim.fn.stdpath("config") .. "/lua"] = true,
                                        vim.env.VIMRUNTIME
                                        -- "${3rd}/luv/library"
                                        -- "${3rd}/busted/library",
                                    }
                                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                                    -- library = vim.api.nvim_get_runtime_file("", true)
                                },
                                completion = {
                                    callSnippet = "Replace"
                                }
                                -- runtime = {
                                --     -- Tell the language server which version of Lua you're using
                                --     -- (most likely LuaJIT in the case of Neovim)
                                --     version = 'LuaJIT'
                                -- },
                            }
                        })

                        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                    end
                    return true
                end
            })

            lspconfig["jdtls"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            lspconfig["volar"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
            })

            lspconfig["lemminx"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            lspconfig["pyright"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            lspconfig["gopls"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            -- lspconfig["rust_analyzer"].setup({
            --     capabilities = capabilities,
            --     on_attach = on_attach,
            --     filetypes = { "rust" },
            --     -- root_dir = util.root_pattern("Cargo.toml"),
            --     settings = {
            --         ["rust-analyzer"] = {
            --             cargo = {
            --                 allFeatures = true,
            --             },
            --         }
            --     }
            -- })

            lspconfig["taplo"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            lspconfig["clangd"].setup({
                capabilities = capabilities,
                on_attach = function()
                    on_attach()
                    require("clangd_extensions.inlay_hints").setup_autocmd()
                    require("clangd_extensions.inlay_hints").set_inlay_hints()
                end,
            })
        end,
    },
    {
        "lvimuser/lsp-inlayhints.nvim",
        dependencies = "neovim/nvim-lspconfig"
    }
}
