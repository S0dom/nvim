return {
    {
        'cameron-wags/rainbow_csv.nvim',
        config = true,
        ft = {
            'csv',
            'tsv',
            'csv_semicolon',
            'csv_whitespace',
            'csv_pipe',
            'rfc_csv',
            'rfc_semicolon'
        },
        cmd = {
            'RainbowDelim',
            'RainbowDelimSimple',
            'RainbowDelimQuoted',
            'RainbowMultiDelim'
        }
    },
    {
        'vidocqh/data-viewer.nvim',
        ft = {
            'csv',
            'tsv',
            'csv_semicolon',
            'csv_whitespace',
            'csv_pipe',
            'rfc_csv',
            'rfc_semicolon'
        },
        opts = {},
        dependencies = {
            "nvim-lua/plenary.nvim",
            "kkharji/sqlite.lua", -- Optional, sqlite support
        },
        keys = {
            { "<leader>lcv", "<cmd>DataViewer csv<CR>", desc = "View CSV" },
        }
    },
}
