return {
  name = "dotnet run",
  builder = function()
    return {
      cmd = {"dotnet", "run"},
      components = {{"open_output", focus = true}, {"on_exit_set_status"}}
    }
  end,
  condition = {
    filetype = {"cs", "razor"}
  }
}
