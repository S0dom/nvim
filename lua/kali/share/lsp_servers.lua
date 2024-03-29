-- used to enable autocompletion (assign to every lsp server config)
local on_attach, capabilities = require("kali.share.utils")

local capabilitiesHTMLCss = vim.lsp.protocol.make_client_capabilities()
capabilitiesHTMLCss.textDocument.completion.completionItem.snippetSupport = true

local servers = {
    html = {
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
    },
    cssls = {
        capabilities = capabilitiesHTMLCss,
        on_attach = on_attach,
    },
    emmet_language_server = {
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
    },
    tailwindcss = {
        capabilities = capabilities,
        on_attach = on_attach,
        filetype_exlude = { "markdown" }
    },
    eslint = {
        settings = {
            workingDirecctory = { mode = "auto" },
        }
    },
    lua_ls = {
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
    },
    volar = {
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

    },
    lemminx = {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg', 'fxml' },
    },
    pyright = {
        capabilities = capabilities,
        on_attach = on_attach,
    },
    gopls = {
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
    },
    taplo = {
        capabilities = capabilities,
        on_attach = on_attach,
    },
    clangd = {
        capabilities = capabilities,
        on_attach = function()
            on_attach()
            require("clangd_extensions.inlay_hints").setup_autocmd()
            require("clangd_extensions.inlay_hints").set_inlay_hints()
        end,
    },
    jsonls = {
        capabilities = capabilities,
        on_attach = on_attach,
    },
    omnisharp = {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "dotnet", "/home/kali/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll" },
        organize_imports_on_format = true,
        enable_import_completion = true,
    },
    bashls = {
        capabilities = capabilities,
        on_attach = on_attach,
    },
    marksman = {
        capabilities = capabilities,
        on_attach = on_attach,
    },
    grammarly = {
        capabilities = capabilities,
        on_attach = on_attach,
    },
    phpactor = {
        capabilities = capabilities,
        on_attach = on_attach,
    },
    kotlin_language_server = {
        capabilities = capabilities,
        on_attach = on_attach,
    },

    -- install typescript and angular/language-server in project:
    -- npm install --save-dev typescript
    -- npm install --save-dev @angular/language-service

    angularls = {
        capabilities = capabilities,
        on_attach = on_attach,
    },
    ltex = {
        capabilities = capabilities,
        on_attach = on_attach,
    },
    -- tsserver = {
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
    -- },
}
return servers
