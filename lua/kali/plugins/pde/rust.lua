return {
    {
        "simrat39/rust-tools.nvim",
        ft = { "rust" },
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
            "mfussenegger/nvim-dap",
        },
        config = function()
            local mason_registry = require("mason-registry")

            local codelldb = mason_registry.get_package("codelldb")
            local extension_path = codelldb:get_install_path() .. "/extension/"
            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

            local rt = require("rust-tools")
            rt.setup({
                dap = {
                    adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
                },
                server = {
                    capabilities = require("cmp_nvim_lsp").default_capabilities(),
                    on_attach = function(_, bufnr)
                        vim.keymap.set("n", "<Leader>k", rt.hover_actions.hover_actions, { buffer = bufnr })
                        vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
                    end,
                },
                tools = {
                    autoSetHints = false,
                },
                on_initialized = function()
                    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
                        pattern = { "*.rs" },
                        callback = function()
                            vim.lsp.codelens.refresh()
                        end,
                    })
                end,
            })
        end
    },
    -- {
    --         "mfussenegger/nvim-dap",
    --     config = function ()
    --         local codelldb_path, _ = get_codelldb()
    --         local dap = require("dap")
    --         dap.adapters.codellb = {
    --             type = "server",
    --             port = "${port}",
    --             executable = {
    --                 command = codelldb_path,
    --                 args = { "--port", "${port}" },
    --
    --                 -- Uncomment this on windows:
    --                 -- detached = false,
    --             }
    --         }
    --     end
    -- }
}
