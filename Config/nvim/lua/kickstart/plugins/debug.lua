-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)



return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'jedrzejboczar/nvim-dap-cortex-debug',
    "mfussenegger/nvim-dap-python",
    "mrcjkb/rustaceanvim",
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        local dap = require('dap')
        if dap.session() then
          dap.continue()
        elseif vim.bo.filetype == 'rust' then
          vim.cmd('RustLsp debuggables')
        else
          if _G.dap_has_run then
            dap.run_last()
          else
            dap.continue()
          end
        end
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F17>', -- Shift + F5
      function()
        require('dap').terminate()
        require('dapui').close()
      end,
      desc = 'Debug: Terminate Session',
    },
    {
      '<F11>',
      function() require('dap').step_into() end,
      desc = 'Debug: Step Into',
    },
    {
      '<F10>',
      function() require('dap').step_over() end,
      desc = 'Debug: Step Over',
    },
    {
      '<F23>',
      function() require('dap').step_out() end,
      desc = 'Debug: Step Out',
    },
    {
      '<F9>',
      function() require('dap').toggle_breakpoint() end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<F8>',
      function() require('dapui').toggle() end,
      desc = 'Debug: See last session result.',
    },
    {
      '<F1>',
      function() require("dapui").eval() end,
      desc = 'Debug: Hover Value',
    },
  },


  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('dap-cortex-debug').setup {
      debug_adapter = 'cortex-debug'
    }
    require('mason-nvim-dap').setup {
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
        -- 'delve',
        "python",
        "bash",
        "codelldb",
        "cortex-debug",
        "cpptools",
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
    and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
    dap.listeners.after.event_initialized['set_run_flag'] = function()
      _G.dap_has_run = true
    end


    -- Install golang specific config
    -- require('dap-go').setup {
    --   delve = {
    --     -- On Windows delve must be run attached or it crashes.
    --     -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
    --     detached = vim.fn.has 'win32' == 0,
    --   },
    -- }

    -- C for embedded system
    dap.adapters.cppdbg = {
      id = 'cppdbg',
      type = 'executable',
      command = vim.fn.stdpath('data') .. '/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
    }

    local function find_main()
      local search_path = vim.fn.getcwd() .. "/**/";
      local main_file = vim.fn.glob(search_path .. "main", true, true)
    end

    _G.find_elf = function(prompt_msg)
      local search_path = vim.fn.getcwd() .. "/build/"
      local elf_files = vim.fn.glob(search_path .. '*.elf', true, true)

      if #elf_files == 1 then
        return elf_files[1]
      else
        if #elf_files == 0 then
          print("Cannot find ELF file in: " .. search_path)
        else
          print("Multiple ELF file..")
        end
        return vim.fn.input(prompt_msg, search_path, 'file')
      end
    end

    local original_run = dap.run
    dap.run = function(config, opts)
      if config.build_command then
        print("Building session: [" .. config.name .. "]...")
        vim.fn.jobstart(config.build_command, {
          on_exit = function(_, code)
            if code == 0 then
              print("Start debugging")
              original_run(config, opts)
            else
              vim.notify("Building error", vim.log.levels.ERROR)
            end
          end,
          stdout_buffered = true,
          stderr_buffered = true,
        })
      else
        original_run(config, opts)
      end
    end

    dap.configurations.c = {
      {
        name = "Native GDB",
        type = "cppdbg",
        request = "launch",
        program = "main",
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
        miDebuggerPath = "gdb",
        setupCommands = {
          { text = '-enable-pretty-printing', description = 'Enable pretty printing', ignoreFailures = false },
        },
      },
    }

    local arm_cfg = require('kickstart.plugins.upDebugConfig.arm')
    local esp32c3_cfg = require('kickstart.plugins.upDebugConfig.esp32c3')
    local esp32s3_cfg = require('kickstart.plugins.upDebugConfig.esp32s3')

    vim.list_extend(dap.configurations.c , arm_cfg)
    vim.list_extend(dap.configurations.c , esp32c3_cfg)
    -- vim.list_extend(dap.configurations.c , esp32s3_cfg)

    -- Cpp for embedded
    dap.configurations.cpp = dap.configurations.c
  end,
}
