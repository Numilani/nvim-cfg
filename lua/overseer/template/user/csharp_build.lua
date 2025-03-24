return {
  name = "dotnet build",
  builder = function()
    return {
      cmd = { "dotnet", "build" },
      args = {"--verbosity", "detailed", "--no-incremental", "-nologo", "-consoleloggerparameters:NoSummary"},
      components = {{ "on_output_quickfix", errorformat = "%*[^/]%f(%l\\,%c): %t%*[^:]: %m", set_diagnostics = true, items_only = true }, { "on_complete_notify" }, { "on_exit_set_status" } },
      strategy = {"jobstart", use_terminal = false},
    }
  end,
  condition = {
    filetype = { "cs", "razor" }
  }
}
