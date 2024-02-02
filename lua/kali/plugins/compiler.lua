return { -- This plugin
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = {
        -- The task runner we use
        "stevearc/overseer.nvim",
        commit = "400e762648b70397d0d315e5acaf0ff3597f2d8b",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        opts = {
            task_list = {
                direction = "bottom",
                min_height = 25,
                max_height = 25,
                default_detail = 1
            },
        },
    },
    opts = {
        vim.api.nvim_set_keymap('n', '<F6>', "<cmd>CompilerOpen<CR>", { noremap = true, silent = true }),
        vim.api.nvim_set_keymap('n', '<S-F6>',
            "<cmd>CompilerStop<cr>" -- (Optional, to dispose all tasks before redo)
            .. "<cmd>CompilerRedo<cr>",
            { noremap = true, silent = true }),
        -- Toggle compiler results
        vim.api.nvim_set_keymap('n', '<S-F7>', "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true }),
        vim.api.nvim_set_keymap('n', '<F8>', "<cmd>CompilerStop<CR>", { noremap = true, silent = true })
    },
}
