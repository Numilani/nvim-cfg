return {
  name = "dotnet watch run",
  builder = function()
    return {
      cmd = {"dotnet", "watch", "run"},
      components = {{"open_output", focus = true}, {"on_exit_set_status"}}
    }
  end,
  condition = {
    filetype = {"cs", "razor"}
  }
}
