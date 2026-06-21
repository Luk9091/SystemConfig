return {
    {
        name = "ESP32S3 GDB",
        type = "cortex-debug",
        request = "launch",
        servertype = "external",
        gdbTarget = "localhost:3333",
        cwd = '${workspaceFolder}',
        executable = function()
          return _G.find_elf("ELF file path (ESP32)")
        end,
        gdbPath = "xtensa-esp32s3-elf-gdb",
        toolchainPath = "",
        timeout = 10000,
        build_command = "idf.py build",
        overrideLaunchCommands = {
          "target extended-remote :3333",
          "mon reset halt",
          "thb app_main",
        },
        postLaunchCommands = {},
      }
}
