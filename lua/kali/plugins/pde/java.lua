local function get_jdtls()
    local mason_registry = require "mason-registry"
    local jdtls = mason_registry.get_package "jdtls"
    local jdtls_path = jdtls:get_install_path()
    local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
    local SYSTEM = "linux"
    if vim.fn.has "mac" == 1 then
        SYSTEM = "mac"
    end
    local config = jdtls_path .. "/config_" .. SYSTEM
    local lombok = jdtls_path .. "/lombok.jar"
    return launcher, config, lombok
end

local function get_bundles()
    local mason_registry = require "mason-registry"
    local java_debug = mason_registry.get_package "java-debug-adapter"
    local java_test = mason_registry.get_package "java-test"
    local java_debug_path = java_debug:get_install_path()
    local java_test_path = java_test:get_install_path()
    local bundles = {}
    vim.list_extend(bundles,
        vim.split(vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n"))
    vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n"))
    return bundles
end

local function get_workspace()
    local home = os.getenv "HOME"
    local workspace_path = home .. "/.local/share/nde/jdtls-workspace/"
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = workspace_path .. project_name
    return workspace_dir
end

return {
    {
        "mfussenegger/nvim-jdtls",
        ft = { "java" },
        dependencies = { "mfussenegger/nvim-dap", "neovim/nvim-lspconfig" },
        -- event = "VeryLazy",
        config = function()
            -- Autocmd
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "java" },
                callback = function()
                    -- LSP capabilities
                    local jdtls = require "jdtls"
                    local on_attach, capabilities = require("kali.share.utils")
                    local extendedClientCapabilities = jdtls.extendedClientCapabilities
                    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

                    local launcher, os_config, lombok = get_jdtls()
                    local workspace_dir = get_workspace()
                    local bundles = get_bundles()

                    local features = {
                        -- change this to `true` to enable codelens
                        codelens = true,

                        -- change this to `true` if you have `nvim-dap`,
                        -- `java-test` and `java-debug-adapter` installed
                        debugger = true,
                    }

                    local function on_attach_add(_, bufnr)
                        vim.keymap.set("n", "<leader>ljo", "<cmd>lua require('jdtls').organize_imports()<CR>",
                            { silent = true, buffer = bufnr, noremap = true, desc = "Organize Imports" })
                        vim.keymap.set("n", "<leader>ljv", "<cmd>lua require('jdtls').extract_variable()<CR>",
                            { silent = true, buffer = bufnr, noremap = true, desc = "Extract Variable" })
                        vim.keymap.set("n", "<leader>ljc", "<cmd>lua require('jdtls').extract_constant()<CR>",
                            { silent = true, buffer = bufnr, noremap = true, desc = "Extract Constant" })
                        vim.keymap.set("n", "<leader>lju", "<cmd>JdtUpdateConfig<cr>",
                            { silent = true, buffer = bufnr, noremap = true, desc = "Update Config" })
                        vim.keymap.set("v", "<leader>ljv", "<esc><cmd>lua require('jdtls').extract_variable(true)<CR>",
                            { silent = true, buffer = bufnr, noremap = true, desc = "Extract Variable" })
                        vim.keymap.set("v", "<leader>ljc", "<esc><cmd>lua require('jdtls').extract_constant(true)<CR>",
                            { silent = true, buffer = bufnr, noremap = true, desc = "Extract Constant" })
                        vim.keymap.set("v", "<leader>ljm", "<esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
                            { silent = true, buffer = bufnr, noremap = true, desc = "Extract Method" })

                        vim.lsp.codelens.refresh()
                        jdtls.setup_dap { hotcodereplace = "auto" }
                        require("jdtls.dap").setup_dap_main_class_configs()
                        require("jdtls.setup").add_commands()

                        if features.debugger then
                            vim.keymap.set("n", "<leader>ljt", "<cmd>lua require('jdtls').test_nearest_method()<CR>",
                                { buffer = bufnr, desc = "Test Nearest Method" })
                            vim.keymap.set("n", "<leader>ljT", "<cmd>lua require('jdtls').test_class()<CR>",
                                { buffer = bufnr, desc = "Test Class" })
                        end
                    end

                    local function jdtls_on_attach(client, bufnr)
                        on_attach(client, bufnr)
                        on_attach_add(client, bufnr)
                    end

                    local config = {
                        cmd = {
                            "java",
                            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                            "-Dosgi.bundles.defaultStartLevel=4",
                            "-Declipse.product=org.eclipse.jdt.ls.core.product",
                            "-Dlog.protocol=true",
                            "-Dlog.level=ALL",
                            "-Xms1g",
                            "--add-modules=ALL-SYSTEM",
                            "--add-opens",
                            "java.base/java.util=ALL-UNNAMED",
                            "--add-opens",
                            "java.base/java.lang=ALL-UNNAMED",
                            "-javaagent:" .. lombok,
                            "-jar",
                            launcher,
                            "-configuration",
                            os_config,
                            "-data",
                            workspace_dir,
                        },
                        root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml",
                            "build.gradle" }),
                        capabilities = capabilities,
                        on_attach = jdtls_on_attach,

                        settings = {
                            java = {
                                eclipse = {
                                    downloadSources = true,
                                },
                                configuration = {
                                    updateBuildConfiguration = "interactive",
                                    -- NOTE: Add the available runtimes here
                                    -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                                    runtimes = {
                                        -- {
                                        --     name = "JavaSE-17",
                                        --     path = "~/.sdkman/candidates/java/17.0.10-graal",
                                        -- },
                                    },
                                },
                                maven = {
                                    downloadSources = true,
                                },
                                implementationsCodeLens = {
                                    enabled = true,
                                },
                                referencesCodeLens = {
                                    enabled = true,
                                },
                                references = {
                                    includeDecompiledSources = true,
                                },
                                inlayHints = {
                                    parameterNames = {
                                        enabled = "all", -- literals, all, none
                                    },
                                },
                                format = {
                                    enabled = true,
                                },
                                -- NOTE: We can set the formatter to use different styles
                                -- format = {
                                --   enabled = true,
                                --   settings = {
                                --     url = vim.fn.stdpath "config" .. "/lang-servers/intellij-java-google-style.xml",
                                --     profile = "GoogleStyle",
                                --   },
                                -- },
                            },
                            autobuild = { enabled = true },
                            signatureHelp = { enabled = true },
                            contentProvider = { preferred = "fernflower" },
                            saveActions = {
                                organizeImports = true,
                            },
                            sources = {
                                organizeImports = {
                                    starThreshold = 9999,
                                    staticStarThreshold = 9999,
                                },
                            },
                            codeGeneration = {
                                toString = {
                                    template =
                                    "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                                },
                                hashCodeEquals = {
                                    useJava7Objects = true,
                                },
                                useBlocks = true,
                            },
                        },
                        init_options = {
                            bundles = bundles,
                            extendedClientCapabilities = extendedClientCapabilities,
                        },
                    }
                    require("jdtls").start_or_attach(config)
                end,
            })
        end,
    },
}
