return {
    {
        "folke/neodev.nvim",
        config = function()
            local neodev = require("neodev")
            neodev.setup({
                library = {
                    enabled = true,     -- when not enabled, neodev will not change any settings to the LSP server
                    -- these settings will be used for your Neovim config directory
                    runtime = true,     -- runtime path
                    types = true,       -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
                    plugins = { "nvim-dap-ui", true},     -- installed opt or start plugins in packpath
                    -- you can also specify the list of plugins to make available as a workspace library
                    -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
                },
                setup_jsonls = true,     -- configures jsonls to provide completion for project specific .luarc.json files
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
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            local keymap = vim.keymap.set
            local opts = { noremap = true, silent = true }
            local on_attach = function(client, bufnr)
                -- set keymap
                opts.desc = "Show LSP references"
                keymap("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

                opts.desc = "Go to declaration"
                keymap("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

                opts.desc = "Show LSP definitions"
                keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

                opts.desc = "Show LSP implementations"
                keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

                opts.desc = "Show LSP type definitions"
                keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

                opts.desc = "See available code actions"
                keymap({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

                opts.desc = "Smart rename"
                keymap("n", "<leader>lr", vim.lsp.buf.rename, opts) -- smart rename

                opts.desc = "Show buffer diagnostics"
                keymap("n", "<leader>ldD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show diagnostics for file

                opts.desc = "Show line diagnostics"
                keymap("n", "<leader>ldd", vim.diagnostic.open_float, opts) -- show diagnostics for line

                opts.desc = "Go to next diagnostic"
                keymap("n", "<leader>ldn", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

                opts.desc = "Go to previous diagnostic"
                keymap("n", "<leader>ldp", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

                opts.desc = "Show documentation for what is under cursor"
                keymap("n", "<leader>lK", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

                opts.desc = "Restart LSP"
                keymap("n", "<leader>lR", "<cmd>LspRestart<CR>", opts) -- mapping to restart lsp if necessary

                require("illuminate").on_attach(client)
            end

            -- used to enable autocompletion (assign to every lsp server config)
            local capabilities = cmp_nvim_lsp.default_capabilities()

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
        end,
    }
}
