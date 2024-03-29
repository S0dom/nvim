return {
    "gbprod/yanky.nvim",
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    config = function()
        vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put After" })
        vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put Before" })
        vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "Put After (Before)" })
        vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "Put Before (Before)" })

        vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)", { desc = "Previous Yanky Entry" })
        vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)", { desc = "Next Yanky Entry" })

        vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put Indent After Linewise (After)" })
        vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put Indent After Linewise (Before)" })
        vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put Indent Before Linewise (After)" })
        vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)",
            { desc = "Put Indent Before Linewise (Before)" })

        vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)",
            { desc = "Put Indent After Shift Right (After)" })
        vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)",
            { desc = "Put Indent After Shift Left (Before)" })
        vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)",
            { desc = "Put Indent Before Shift Right (After)" })
        vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)",
            { desc = "Put Indent Before Shift Left (Before)" })

        vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)", { desc = "Put After Filter" })
        vim.keymap.set("n", "=P", "<Plug>(YankyPutBeforeFilter)", { desc = "Put Before Filter" })

        vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)", { desc = "Yank" })

        vim.keymap.set("n", "<leader>y", "<cmd>Telescope yank_history<CR>", { desc = "Yank History" })

        require("yanky").setup({
            ring = {
                history_length = 100,
                storage = "shada",
                sync_with_numbered_registers = true,
                cancel_event = "update",
                ignore_registers = { "_" },
                update_register_on_cycle = false,
            },
            system_clipboard = {
                sync_with_ring = true,
            },
        })
    end
}
