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

            local servers = require("kali.share.lsp_servers")

            for server, config in pairs(servers) do
                lspconfig[server].setup(config)
            end
        end,
    },
    {
        "lvimuser/lsp-inlayhints.nvim",
        dependencies = "neovim/nvim-lspconfig"
    }
}
