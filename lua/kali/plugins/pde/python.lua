return {
    {
        "mfussenegger/nvim-dap-python",
        ft = { "python" },
        config = function()
            local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
            require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python3")
        end
    },
}
