return {
    "mfussenegger/nvim-dap",
    opts = function()
        local dap = require("dap")

        vim.api.nvim_create_user_command("DapResetArgs", function()
            _G.dap_python_args = nil
            print("DAP: Zresetowano zapamiętane parametry Pythona.")
        end, {})

        local function get_python_args()
            if _G.dap_python_args ~= nil then
                return _G.dap_python_args
            end

            local args_str = vim.fn.input("Arguments (space separate): ")
            _G.dap_python_args = vim.split(args_str, "%s+", { trimempty = true })

            return _G.dap_python_args
        end

        dap.configurations.python = dap.configurations.python or {}

        table.insert(dap.configurations.python, 1, {
            type = "python",
            request = "launch",
            name = "Launch Python (Własne parametry / Pamięć sesji)",
            program = "${file}",
            args = get_python_args,
            console = "integratedTerminal",
        })
    end
}
