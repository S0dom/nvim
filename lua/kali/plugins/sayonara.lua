return {
    "mhinz/vim-sayonara",
    config = function ()
        local keymap = vim.keymap.set

        keymap("n", "<leader>c", "<cmd>Sayonara!<CR>", { desc = "Close Buffer" })
    end
}
