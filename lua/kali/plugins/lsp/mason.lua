return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")

        mason.setup()

        mason_lspconfig.setup({
            ensure_installed = {
                "lua_ls",
                "html",
                "jdtls",
                "pyright",
                "gopls",
                "rust_analyzer",
                "clangd",
                -- "volar",
            },
            -- auto-install configured servers (with lspconfig)
            automatic_installation = false, -- not the same as ensure_installed
        })
    end
}
