return {
  name = "gcc build",
  builder = function()
    local file = vim.fn.expand("%:p")
    local buildname = vim.fn.expand("%:r")
    return {
      cmd = {"gcc"},
      args = {file, "-o", buildname},
      components = {{"open_output", focus = true}, {"on_exit_set_status"}}
    }
  end,
  condition = {
    filetype = {"c", "cpp"}
  }
}
