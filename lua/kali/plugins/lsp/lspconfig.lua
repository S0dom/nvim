return {
    {
        "folke/neodev.nvim",
        opts = function()
            return {
                library = {
                    enabled = true,                                       -- when not enabled, neodev will not change any settings to the LSP server
                    -- these settings will be used for your Neovim config directory
                    runtime = true,                                       -- runtime path
                    types = true,                                         -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
                    plugins = { "nvim-dap-ui", "neotest", types = true }, -- installed opt or start plugins in packpath
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
            }
        end
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            { "antosha417/nvim-lsp-file-operations", config = true },
        },
        opts = {
            setup = {
                omnisharp = function()
                    local lsp_utils = require "base.lsp.utils"
                    lsp_utils.on_attach(function(client, bufnr)
                        if client.name == "omnisharp" then
                            local map = function(mode, lhs, rhs, desc)
                                if desc then
                                    desc = desc
                                end
                                vim.keymap.set(mode, lhs, rhs,
                                    { silent = true, desc = desc, buffer = bufnr, noremap = true })
                            end

                            -- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483
                            local function toSnakeCase(str)
                                return string.gsub(str, "%s*[- ]%s*", "_")
                            end

                            local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend
                                .tokenModifiers
                            for i, v in ipairs(tokenModifiers) do
                                tokenModifiers[i] = toSnakeCase(v)
                            end
                            local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
                            for i, v in ipairs(tokenTypes) do
                                tokenTypes[i] = toSnakeCase(v)
                            end

                            -- C# keymappings
                            -- stylua: ignore
                            map("n", "<leader>td",
                                "<cmd>w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = require('neotest-dotnet.strategies.netcoredbg'), is_custom_dotnet_debug = true})<cr>",
                                "Debug File")

                            -- stylua: ignore
                            map("n", "<leader>tL",
                                "<cmd>w|lua require('neotest').run.run_last({strategy = require('neotest-dotnet.strategies.netcoredbg'), is_custom_dotnet_debug = true})<cr>",
                                "Debug Last")

                            -- stylua: ignore
                            map("n", "<leader>tN",
                                "<cmd>w|lua require('neotest').run.run({strategy = require('neotest-dotnet.strategies.netcoredbg'), is_custom_dotnet_debug = true})<cr>",
                                "Debug Nearest")
                        end
                    end)
                end,
                eslint = function()
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        callback = function(event)
                            local client = vim.lsp.get_active_clients({ bufnr = event.buf, name = "eslint" })[1]
                            if client then
                                local diag = vim.diagnostic.get(event.buf,
                                    { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
                                if #diag > 0 then
                                    vim.cmd "EslintFixAll"
                                end
                            end
                        end,
                    })
                end,
            },
        },
        config = function()
            local lspconfig = require("lspconfig")

            -- used to enable autocompletion (assign to every lsp server config)
            -- local capabilities = cmp_nvim_lsp.default_capabilities()
            local on_attach, capabilities = require("kali.share.utils")

            local capabilitiesHTMLCss = vim.lsp.protocol.make_client_capabilities()
            capabilitiesHTMLCss.textDocument.completion.completionItem.snippetSupport = true

            lspconfig.html.setup({
                capabilities = capabilitiesHTMLCss,
                on_attach = on_attach,
                filetypes = { "html", "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact",
                    "typescript.tsx" },
                init_options = {
                    configurationSection = { "html", "css", "javascript" },
                    embeddedLanguages = {
                        css = true,
                        javascript = true
                    },
                    provideFormatter = false
                }
            })

            lspconfig.cssls.setup({
                capabilities = capabilitiesHTMLCss,
                on_attach = on_attach,
            })

            lspconfig.emmet_language_server.setup({
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
                    html = {
                        options = {
                            -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                            ["bem.enabled"] = true,
                        },
                    },
                },
            })

            -- lspconfig.tsserver.setup({
            --     capabilities = capabilities,
            --     on_attach = on_attach,
            --     init_options = {
            --         preferences = {
            --             disableSuggestions = true,
            --         }
            --     },
            --     settings = {
            --         typescript = {
            --             format = {
            --                 indentSize = vim.o.shiftwidth,
            --                 convertTabsToSpaces = vim.o.expandtab,
            --                 tabSize = vim.o.tabstop,
            --             }
            --         },
            --         javascript = {
            --             format = {
            --                 indentSize = vim.o.shiftwidth,
            --                 convertTabsToSpaces = vim.o.expandtab,
            --                 tabSize = vim.o.tabstop,
            --             }
            --         },
            --         completion = {
            --             completeFunctionCalls = true,
            --         },
            --     },
            -- })

            lspconfig.tailwindcss.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                filetype_exlude = { "markdown" }
            })

            lspconfig.eslint.setup({
                settings = {
                    workingDirecctory = { mode = "auto" },
                }
            })

            lspconfig.lua_ls.setup({
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
                                },
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

            lspconfig.volar.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { 'vue' }, -- if typescript-tools still slow : { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }, --, 'json' },
                init_options = {
                    typescript = {
                        tsdk =
                            vim.env.HOME ..
                            '/.local/share/nvim/mason/packages/vue-language-server/node_modules/typescript/lib'
                    },
                    languageFeatures = {
                        implementation = true,
                        references = true,
                        definition = true,
                        typeDefinition = true,
                        callHierarchy = true,
                        hover = true,
                        rename = true,
                        renameFileRefactoring = true,
                        signatureHelp = true,
                        codeAction = true,
                        workspaceSymbol = true,
                        diagnostics = true,
                        semanticTokens = true,
                        completion = {
                            defaultTagNameCase = 'both',
                            defaultAttrNameCase = 'kebabCase',
                            getDocumentNameCasesRequest = false,
                            getDocumentSelectionRequest = false,
                        },
                    }
                },
            })

            lspconfig.lemminx.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg', 'fxml' },
            })

            lspconfig.pyright.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            lspconfig.gopls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    gopls = {
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                    },
                },
            })

            lspconfig.taplo.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            lspconfig.clangd.setup({
                capabilities = capabilities,
                on_attach = function()
                    on_attach()
                    require("clangd_extensions.inlay_hints").setup_autocmd()
                    require("clangd_extensions.inlay_hints").set_inlay_hints()
                end,
            })

            lspconfig.jsonls.setup {
                capabilities = capabilities,
                on_attach = on_attach,
            }

            lspconfig.omnisharp.setup {
                capabilities = capabilities,
                on_attach = on_attach,
                cmd = { "dotnet", "/home/kali/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll" },
                organize_imports_on_format = true,
                enable_import_completion = true,
            }

            lspconfig.bashls.setup {
                capabilities = capabilities,
                on_attach = on_attach,
            }

            lspconfig.marksman.setup {
                capabilities = capabilities,
                on_attach = on_attach,
            }

            lspconfig.grammarly.setup {
                capabilities = capabilities,
                on_attach = on_attach,
            }

            lspconfig.phpactor.setup {
                capabilities = capabilities,
                on_attach = on_attach,
            }

            lspconfig.kotlin_language_server.setup {
                capabilities = capabilities,
                on_attach = on_attach,
            }

            -- install typescript and angular/language-server in project:
            -- npm install --save-dev typescript
            -- npm install --save-dev @angular/language-service

            lspconfig.angularls.setup {
                capabilities = capabilities,
                on_attach = on_attach,
            }

            lspconfig.ltex.setup {
                capabilities = capabilities,
                on_attach = on_attach,
            }
        end,
    },
    {
        "lvimuser/lsp-inlayhints.nvim",
        dependencies = "neovim/nvim-lspconfig"
    }
}
