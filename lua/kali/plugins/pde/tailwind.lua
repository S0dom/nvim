return {
    --     {
    --         "hrsh7th/nvim-cmp",
    --         dependencies = {
    --             { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    --         },
    --         opts = function(_, opts)
    --             local format_kinds = opts.formatting.format
    --             opts.formatting.format = function(entry, item)
    --                 format_kinds(entry, item)
    --                 return require("tailwindcss-colorizer-cmp").formatter(entry, item)
    --             end
    --         end,
    --     },
}
