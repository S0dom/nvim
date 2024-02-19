local icons = require "kali.share.icons"

return {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig",
    opts = function()
        return {
            icons = icons.navic,
            lsp = {
                auto_attach = true,
                preference = { "typescript-tools" },
            },
            highlight = true,
            separator = " > ",
            depth_limit = 0,
            depth_limit_indicator = "..",
            safe_output = true,
            click = false,
        }
    end
}
