-- 
-- NEOVIM CONFIG ENTRYPOINT
-- 

require("opts")
require("tweaks")

require("config.lazy")

-- If you've installed a new color scheme, you can switch to it here.
vim.cmd.colorscheme("molokai")

require("lsp_settings")
require("debug_opts")

require("keybinds")
