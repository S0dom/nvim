local function get_codelldb()
    local mason_registry = require "mason-registry"
    local codelldb = mason_registry.get_package "codelldb"
    local extension_path = codelldb:get_install_path() .. "/extension/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
    return codelldb_path, liblldb_path
end

return {
    {
        "p00f/clangd_extensions.nvim",
        ft = { "cpp", "c" },
        config = function()
            require("clangd_extensions").setup({
                server = {
                    root_dir = function(...)
                        -- using a root .clang-format or .clang-tidy file messes up projects, so remove them
                        return require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt",
                            "configure.ac", ".git")(...)
                    end,
                    capabilities = {
                        offsetEncoding = { "utf-16" },
                    },
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                        "--fallback-style=llvm",
                    },
                    init_options = {
                        usePlaceholders = true,
                        completeUnimported = true,
                        clangdFileStatus = true,
                    },
                },
                extensions = {
                    inlay_hints = {
                        inline = true,
                    },
                    ast = {
                        --These require codicons (https://github.com/microsoft/vscode-codicons)
                        role_icons = {
                            type = "",
                            declaration = "",
                            expression = "",
                            specifier = "",
                            statement = "",
                            ["template argument"] = "",
                        },
                        kind_icons = {
                            Compound = "",
                            Recovery = "",
                            TranslationUnit = "",
                            PackExpansion = "",
                            TemplateTypeParm = "",
                            TemplateTemplateParm = "",
                            TemplateParamObject = "",
                        },
                    },
                }
            })
        end
    },
    -- {
    --     "mfussenegger/nvim-dap",
    --     opts = {
    --         setup = {
    --             codelldb = function()
    --                 local codelldb_path, _ = get_codelldb()
    --                 local dap = require "dap"
    --                 dap.adapters.codelldb = {
    --                     type = "server",
    --                     port = "12345",
    --                     executable = {
    --                         command = codelldb_path,
    --                         args = { "--port", "12345" },
    --
    --                         -- On windows you may have to uncomment this:
    --                         -- detached = false,
    --                     },
    --                 }
    --                 dap.configurations.cpp = {
    --                     {
    --                         name = "Launch file",
    --                         type = "codelldb",
    --                         request = "launch",
    --                         program = function()
    --                             return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    --                         end,
    --                         cwd = "${workspaceFolder}",
    --                         stopOnEntry = false,
    --                     },
    --                 }
    --
    --                 dap.configurations.c = dap.configurations.cpp
    --                 dap.configurations.rust = dap.configurations.cpp
    --             end,
    --         },
    --     },
    -- },
}
