local function get_codelldb()
    local mason_registry = require("mason-registry")
    local codelldb = mason_registry.get_package("codelldb")
    local extension_path = codelldb:get_install_path() .. "/extension/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
    return codelldb_path, liblldb_path
end

return {
    {
        "simrat39/rust-tools.nvim",
        ft = { "rust" },
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
            "mfussenegger/nvim-dap",
            "rust-lang/rust.vim"
        },
        config = function()
            local rt = require("rust-tools")
            local on_attach, capabilities = require("kali.share.utils")
            local function on_attach_add(_, bufnr)
                -- Hover actions
                vim.keymap.set("n", "<Leader>lK", rt.hover_actions.hover_actions,
                    { buffer = bufnr, desc = "Rust hover", noremap = true, silent = true })
                -- Code action groups
                vim.keymap.set("n", "<Leader>lA", rt.code_action_group.code_action_group,
                    { buffer = bufnr, desc = "Rust code actions", noremap = true, silent = true })
                vim.keymap.set("n", "<leader>dC", "<cmd>RustDebuggables<CR>",
                    { buffer = bufnr, desc = "Rust Debug", noremap = true, silent = true })
                vim.keymap.set("n", "<leader>le", "<cmd>RustRunnables<CR>",
                    { buffer = bufnr, desc = "Rust Run", noremap = true, silent = true })
                vim.keymap.set("n", "<leader>ll", function() vim.lsp.codelens.run() end,
                    { desc = "Code Lens", noremap = true, silent = true })
                vim.keymap.set("n", "<leader>lt", "<cmd>Cargo test<cr>",
                    { desc = "Cargo test", noremap = true, silent = true })
                vim.keymap.set("n", "<leader>lE", "<cmd>Cargo run<cr>",
                    { desc = "Cargo run", noremap = true, silent = true })
            end
            local function rt_on_attach(client, bufnr)
                on_attach(client, bufnr)
                on_attach_add(client, bufnr)
            end
            local codelldb_path, liblldb_path = get_codelldb()
            vim.api.nvim_create_autocmd({ "BufEnter" }, {
                pattern = { "Cargo.toml" },
                callback = function(event)
                    local bufnr = event.buf

                    vim.keymap.set("n", "<leader>lcy", "<cmd>lua require'crates'.open_repository()<cr>",
                        { desc = "Open Repository", noremap = true, silent = true })
                    vim.keymap.set("n", "<leader>lcp", "<cmd>lua require'crates'.show_popup()<cr>",
                        { desc = "Show Popup", noremap = true, silent = true })
                    vim.keymap.set("n", "<leader>lci", "<cmd>lua require'crates'.show_crate_popup()<cr>",
                        { desc = "Show Info", noremap = true, silent = true })
                    vim.keymap.set("n", "<leader>lcf", "<cmd>lua require'crates'.show_features_popup()<cr>",
                        { desc = "Show Features", noremap = true, silent = true })
                    vim.keymap.set("n", "<leader>lcd", "<cmd>lua require'crates'.show_dependencies_popup()<cr>",
                        { desc = "Show Dependencies", noremap = true, silent = true })
                end,
            })
            rt.setup({
                tools = {
                    autoSetHints = true,
                    runnables = { use_telescope = true },
                    inlay_hints = { show_parameter_hints = true },
                    hover_actions = { auto_focus = true },
                    on_initialized = function()
                        vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
                            pattern = { "*.rs" },
                            callback = function()
                                vim.lsp.codelens.refresh()
                            end,
                        })
                    end,
                },
                server = {
                    on_attach = rt_on_attach,
                    capabilities = capabilities,
                    ["rust-analyzer"] = {
                        assist = {
                            importEnforceGranularity = true,
                            importPrefix = "crate",
                        },
                        cargo = { allFeatures = true },
                        checkOnSave = {
                            command = "cargo clippy",
                            allFeatures = true,
                        }
                    },
                },
                dap = {
                    adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
                },
            })
        end
    },
    {
        "saecki/crates.nvim",
        ft = { "rust", "toml" },
        event = { "BufRead Cargo.toml" },
        config = function(_, opts)
            local crates = require("crates")
            crates.setup(opts)
            crates.show()
        end,
    },
}
