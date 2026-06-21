return {
    {
      name = "ARM Cortex GDB (Check if work)",
      type = "cortex-debug",
      request = "launch",
      servertype="external",
      gdbTarget = "localhost:3333",
      cwd = '${workspaceFolder}',
      executable = function()
        return _G.find_elf("ELF file path (Cortex)")
      end,
      gdbPath = "gdb-multiarch",
      runToEntryPoint = "main",
      timeout = 10000,
      build_command = "cmake --build build -j8",
      overrideLaunchCommands = {
        "target extended-remote :3333",
        "mon reset halt",
        "thb main",
      },
      postLaunchCommands = {},
    }
}
