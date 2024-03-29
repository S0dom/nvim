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

    opts.desc = "Format"
    keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>", opts)

    if client.supports_method("textDocument/formatting") then
        local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                vim.notify(
                    "Formatting file using: " .. client.name,
                    vim.log.levels.INFO,
                    { title = "Formatting" }
                )
                vim.lsp.buf.format({
                    bufnr = bufnr,
                })
            end,
        })
    end
end

local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true

return on_attach, capabilities
