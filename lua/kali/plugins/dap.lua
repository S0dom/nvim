local icons = require "kali.share.icons"

return {
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        dependencies = {
            -- fancy UI for the debugger
            {
                "rcarriga/nvim-dap-ui",
                -- stylua: ignore
                keys = {
                    { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
                    { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
                },
                opts = function()
                    local dap = require("dap")
                    local dapui = require("dapui")
                    dapui.setup()
                    dap.listeners.after.event_initialized["dapui_config"] = function()
                        dapui.open({})
                    end
                    dap.listeners.before.event_terminated["dapui_config"] = function()
                        dapui.close({})
                    end
                    dap.listeners.before.event_exited["dapui_config"] = function()
                        dapui.close({})
                    end
                end,
            },
            -- virtual text for the debugger
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {},
            },
            -- mason.nvim integration
            {
                "jay-babu/mason-nvim-dap.nvim",
                dependencies = "mason.nvim",
                cmd = { "DapInstall", "DapUninstall" },
                opts = {
                    -- Makes a best effort to setup the various debuggers with
                    -- reasonable debug configurations
                    automatic_installation = true,
                    -- You can provide additional configuration to the handlers,
                    -- see mason-nvim-dap README for more information
                    handlers = {},
                    -- You'll need to check that you have the required things installed
                    -- online, please don't ask me how to install them :)
                    ensure_installed = {
                        -- Update this to ensure that you have the debuggers for the langs you want
                        "python",
                        "delve",
                        "codelldb",
                        "javadbg",
                        "javatest",
                    },
                },
            },
            {
                "nvim-telescope/telescope-dap.nvim"
            },
            { "mxsdev/nvim-dap-vscode-js", module = { "dap-vscode-js" } },
            {
                "microsoft/vscode-js-debug",
                opt = true,
                build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
            },
        },
        -- stylua: ignore
        keys = {
            {
                "<leader>dB",
                function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
                desc =
                "Breakpoint Condition"
            },
            {
                "<leader>db",
                function() require("dap").toggle_breakpoint() end,
                desc =
                "Toggle Breakpoint"
            },
            {
                "<leader>dc",
                function() require("dap").continue() end,
                desc =
                "Continue"
            },
            {
                "<leader>dC",
                function() require("dap").run_to_cursor() end,
                desc =
                "Run to Cursor"
            },
            {
                "<leader>dg",
                function() require("dap").goto_() end,
                desc =
                "Go to line (no execute)"
            },
            {
                "<leader>di",
                function() require("dap").step_into() end,
                desc =
                "Step Into"
            },
            {
                "<leader>dj",
                function() require("dap").down() end,
                desc =
                "Down"
            },
            { "<leader>dk", function() require("dap").up() end, desc = "Up" },
            {
                "<leader>dl",
                function() require("dap").run_last() end,
                desc =
                "Run Last"
            },
            {
                "<leader>do",
                function() require("dap").step_out() end,
                desc =
                "Step Out"
            },
            {
                "<leader>dO",
                function() require("dap").step_over() end,
                desc =
                "Step Over"
            },
            {
                "<leader>dp",
                function() require("dap").pause() end,
                desc =
                "Pause"
            },
            {
                "<leader>dr",
                function() require("dap").repl.toggle() end,
                desc =
                "Toggle REPL"
            },
            {
                "<leader>ds",
                function() require("dap").session() end,
                desc =
                "Session"
            },
            {
                "<leader>dt",
                function() require("dap").terminate() end,
                desc =
                "Terminate"
            },
            {
                "<leader>dw",
                function() require("dap.ui.widgets").hover() end,
                desc =
                "Widgets"
            },
        },
        opts = function()
            local dap = require("dap")
            if not dap.adapters["codelldb"] then
                require("dap").adapters["codelldb"] = {
                    type = "server",
                    host = "localhost",
                    port = "${port}",
                    executable = {
                        command = "codelldb",
                        args = {
                            "--port",
                            "${port}",
                        },
                    },
                }
            end
            for _, lang in ipairs({ "c", "cpp", "rust" }) do
                dap.configurations[lang] = {
                    {
                        type = "codelldb",
                        request = "launch",
                        name = "Launch file",
                        program = function()
                            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                        end,
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "codelldb",
                        request = "attach",
                        name = "Attach to process",
                        processId = require("dap.utils").pick_process,
                        cwd = "${workspaceFolder}",
                    },
                }
            end

            local function get_js_debug()
                local path = vim.fn.stdpath "data"
                return path .. "/lazy/vscode-js-debug"
            end

            require("dap-vscode-js").setup {
                -- node_path = "node",
                debugger_path = get_js_debug(),
                adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
            }

            -- dap.adapters["pwa-node"] = {
            --     type = "server",
            --     host = "127.0.0.1",
            --     port = 8123,
            --     executable = {
            --         command = "js-debug-adapter",
            --     }
            -- }

            for _, language in ipairs { "typescript", "javascript" } do
                require("dap").configurations[language] = {
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Launch file",
                        program = "${file}",
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach",
                        processId = require("dap.utils").pick_process,
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Debug Jest Tests",
                        -- trace = true, -- include debugger info
                        runtimeExecutable = "node",
                        runtimeArgs = {
                            "./node_modules/jest/bin/jest.js",
                            "--runInBand",
                        },
                        rootPath = "${workspaceFolder}",
                        cwd = "${workspaceFolder}",
                        console = "integratedTerminal",
                        internalConsoleOptions = "neverOpen",
                    },
                    {
                        type = "pwa-chrome",
                        name = "Attach - Remote Debugging",
                        request = "attach",
                        program = "${file}",
                        cwd = vim.fn.getcwd(),
                        sourceMaps = true,
                        protocol = "inspector",
                        port = 9222, -- Start Chrome google-chrome --remote-debugging-port=9222
                        webRoot = "${workspaceFolder}",
                    },
                    {
                        type = "pwa-chrome",
                        name = "Launch Chrome",
                        request = "launch",
                        url = "http://localhost:5173", -- This is for Vite. Change it to the framework you use
                        webRoot = "${workspaceFolder}",
                        userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
                    },
                }
            end

            for _, language in ipairs { "typescriptreact", "javascriptreact" } do
                require("dap").configurations[language] = {
                    {
                        type = "pwa-chrome",
                        name = "Attach - Remote Debugging",
                        request = "attach",
                        program = "${file}",
                        cwd = vim.fn.getcwd(),
                        sourceMaps = true,
                        protocol = "inspector",
                        port = 9222, -- Start Chrome google-chrome --remote-debugging-port=9222
                        webRoot = "${workspaceFolder}",
                    },
                    {
                        type = "pwa-chrome",
                        name = "Launch Chrome",
                        request = "launch",
                        url = "http://localhost:5173", -- This is for Vite. Change it to the framework you use
                        webRoot = "${workspaceFolder}",
                        userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
                    },
                }
            end

            setup = {
                netcoredbg = function(_, _)
                    local function get_debugger()
                        local mason_registry = require "mason-registry"
                        local debugger = mason_registry.get_package "netcoredbg"
                        return debugger:get_install_path() .. "/netcoredbg"
                    end

                    dap.configurations.cs = {
                        {
                            type = "coreclr",
                            name = "launch - netcoredbg",
                            request = "launch",
                            program = function()
                                return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
                            end,
                        },
                    }
                    dap.adapters.coreclr = {
                        type = "executable",
                        command = get_debugger(),
                        args = { "--interpreter=vscode" },
                    }
                    dap.adapters.netcoredbg = {
                        type = "executable",
                        command = get_debugger(),
                        args = { "--interpreter=vscode" },
                    }
                end
            }
        end,
        config = function()
            vim.fn.sign_define(
                "DapBreakpoint",
                { text = icons.debug.Breakpoint, texthl = "DiagnosticSignError", linehl = "", numhl = "" }
            )
            vim.fn.sign_define(
                "DapBreakpointCondition",
                { text = icons.debug.BreakpointCondition, texthl = "DiagnosticSignError", linehl = "", numhl = "" }
            )
            vim.fn.sign_define(
                "DapBreakpointRejected",
                { text = icons.debug.BreakpointRejected, texthl = "DiagnosticSignError", linehl = "", numhl = "" }
            )
            vim.fn.sign_define(
                "DapLogPoint",
                { text = icons.debug.Logpoint, texthl = "DiagnosticSignError", linehl = "", numhl = "" }
            )
            vim.fn.sign_define(
                "DapStopped",
                { text = icons.debug.Stopped, texthl = "GitSignsAdd", linehl = "", numhl = "" }
            )
        end,
    }
}
