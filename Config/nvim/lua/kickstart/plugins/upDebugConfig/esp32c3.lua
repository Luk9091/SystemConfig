local selected_elf_path = ""

return {
    {
        name = "ESP32C3 GDB",
        type = "cortex-debug",
        request = "launch",
        servertype = "external",
        gdbTarget = "localhost:3333",
        cwd = '${workspaceFolder}',
        executable = function()
          selected_elf_path = _G.find_elf("ELF file path (ESP32)")
          return selected_elf_path
        end,
        gdbPath = "riscv32-esp-elf-gdb",
        toolchainPath = "",
        timeout = 50000,
        build_command = "idf.py build",
        overrideLaunchCommands = function()
            local bin_file = selected_elf_path:gsub("%.elf", ".bin")
            return {
              "target extended-remote :3333",
              "mon reset halt",
              "mon program_esp " .. bin_file .. " 0x10000 verify",
              "mon reset halt",
              "thb app_main",
          }
        end,
        postLaunchCommands = {},
      }
}
