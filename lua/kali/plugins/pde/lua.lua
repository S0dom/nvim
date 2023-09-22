return {
    {
        "jbyuki/one-small-step-for-vimkind",
        ft = { "lua" },
        -- stylua: ignore
        config = function()
            local opts = { silent = true, noremap = true }
            local keymap = vim.keymap.set
            opts.desc = "Adapter Lua Server"
            keymap("n", "<leader>daL", "<cmd>lua require('osv').launch({ port = 8086 })<CR>", opts)
            opts.desc = "Adapter Lua"
            keymap("n", "<leader>dal", "<cmd>lua require('osv').run_this()<CR>", opts)
            local dap = require("dap")
            dap.configurations.lua = {
                {
                    type = "nlua",
                    request = "attach",
                    name = "Attach to running Neovim instance",
                    host = function ()
                        local value = vim.fn.input "Host [127.0.0.1]: "
                        if value ~= "" then
                            return value
                        end
                        return "127.0.0.1"
                    end,
                    port = function ()
                        local val = tonumber(vim.fn.input("Port: ", "54321"))
                        assert(val, "Please provide a port number")
                        return val
                    end,
                },
            }
            dap.adapters.nlua = function(callback, config)
                callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
            end
        end,
    },
    {
        "sam4llis/nvim-lua-gf",
        ft = { "lua" },
    },
}
