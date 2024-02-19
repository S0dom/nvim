return {
    'akinsho/toggleterm.nvim',
    version = "*",
    keys = {
        {
            "<leader>tn",
            "<cmd>lua _NODE_TOGGLE()<cr>",
            desc =
            "Node"
        },
        {
            "<leader>tu",
            "<cmd>lua _NCDU_TOGGLE()<cr>",
            desc =
            "NCDU"
        },
        {
            "<leader>tt",
            "<cmd>lua _HTOP_TOGGLE()<cr>",
            desc =
            "Htop"
        },
        {
            "<leader>tp",
            "<cmd>lua _PYTHON_TOGGLE()<cr>",
            desc =
            "Python"
        },
        {
            "<leader>tf",
            "<cmd>ToggleTerm direction=float<cr>",
            desc =
            "Float"
        },
        {
            "<leader>th",
            "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
            desc =
            "Horizontal"
        },
        {
            "<leader>tv",
            "<cmd>ToggleTerm size=80 direction=vertical<cr>",
            desc =
            "Vertical"
        },
    },
    config = function()
        local toggleterm = require("toggleterm")
        toggleterm.setup({
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.3
                elseif term.direction == "float" then
                    return 20
                end
            end,
            open_mapping = [[<c-t>]],
            hide_numbers = true,
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            direction = "vertical",
            close_on_exit = true,
            shell = vim.o.shell,
            float_opts = {
                border = "curved",
                winblend = 0,
                highlights = {
                    border = "Normal",
                    background = "Normal",
                },
            },
        })

        function _G.set_terminal_keymaps()
            local opts = { noremap = true }
            vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
            vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
            vim.api.nvim_buf_set_keymap(0, "t", "<A-h>", [[<C-\><C-n><C-W>h]], opts)
            vim.api.nvim_buf_set_keymap(0, "t", "<A-j>", [[<C-\><C-n><C-W>j]], opts)
            vim.api.nvim_buf_set_keymap(0, "t", "<A-k>", [[<C-\><C-n><C-W>k]], opts)
            vim.api.nvim_buf_set_keymap(0, "t", "<A-l>", [[<C-\><C-n><C-W>l]], opts)
        end

        vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

        function _LAZYGIT_TOGGLE()
            lazygit:toggle()
        end

        local node = Terminal:new({ cmd = "node", hidden = true })

        function _NODE_TOGGLE()
            node:toggle()
        end

        local ncdu = Terminal:new({ cmd = "ncdu", hidden = true })

        function _NCDU_TOGGLE()
            ncdu:toggle()
        end

        local htop = Terminal:new({ cmd = "htop", hidden = true })

        function _HTOP_TOGGLE()
            htop:toggle()
        end

        local python = Terminal:new({ cmd = "python", hidden = true })

        function _PYTHON_TOGGLE()
            python:toggle()
        end
    end,
}
