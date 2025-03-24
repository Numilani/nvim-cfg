vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.termguicolors = true
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.wrap = false

vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "auto"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"


vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"


-- with lsp_lines we don't need nvim's vtext
vim.diagnostic.config({ virtual_text = false })

-- update cwd when opening folder from cmdline

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local path = vim.fn.expand("%:p:h")
    if vim.fn.isdirectory(path) == 1 then
      vim.cmd("cd " .. path)
    end
  end,
})

-- breakpoint colors

local set_namespace = vim.api.nvim__set_hl_ns or vim.api.nvim_set_hl_ns
local namespace = vim.api.nvim_create_namespace("dap-hlng")
vim.api.nvim_set_hl(namespace, 'DapBreakpoint', { fg = '#eaeaeb', bg = '#ffffff' })
vim.api.nvim_set_hl(namespace, 'DapLogPoint', { fg = '#eaeaeb', bg = '#ffffff' })
vim.api.nvim_set_hl(namespace, 'DapStopped', { fg = '#eaeaeb', bg = '#ffffff' })

vim.fn.sign_define('DapBreakpoint', { text = '•', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl =
'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition',
  { text = '•', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected',
  { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

require("config.lazy")
vim.cmd("colorscheme tokyonight")

-- skeletons
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = {"tasks.json"},
  callback = function() 
    vim.cmd("silent! 0r $XDG_CONFIG_HOME/template/skeletons/tasks.json")
  end
})



-- Keymaps from Other Places
-- (n) <leader>j - flash (acejump)

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

-- UI commands
vim.keymap.set("n", "<leader>w", ":bd<CR>", { desc = "Close Buffer" })
vim.keymap.set("n", "<leader>e", ":Neotree toggle=true<CR>", { desc = "Toggle Filetree" })

-- Buffer/Window commands
vim.keymap.set("n", "<Tab>", ":bn<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-Tab>", ":bp<CR>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<leader><Tab>", "<C-w>w", { desc = "Next Window" })
vim.keymap.set("n", "<leader><S-Tab>", "<C-w>W", { desc = "Prev Window" })

vim.keymap.set("n", "<C-Down>", "<C-w>-", { desc = "+ Win Height" })
vim.keymap.set("n", "<C-Up>", "<C-w>+", { desc = "- Win Height" })
vim.keymap.set("n", "<C-Left>", "<C-w><", { desc = "+ Win Width" })
vim.keymap.set("n", "<C-Right>", "<C-w>>", { desc = "- Win Width" })

vim.keymap.set('n', '<C-t>', "<CMD>lua require'FTerm'.toggle()<CR>", { desc = "Toggle Terminal" })
vim.keymap.set('t', '<C-t>', "<C-\\><c-n><CMD>lua require'FTerm'.toggle()<CR>", { desc = "Toggle Terminal" })

-- Code commands
vim.keymap.set({ "n", "v" }, "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>", { desc = "Code Actions" })
vim.keymap.set("n", "<leader>cd", ":lua require'telescope.builtin'.diagnostics({bufnr=0})<CR>", { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>ct", ":OverseerRun<CR>", {desc = "Run Task..."})
vim.keymap.set({"n", "i"}, "<C-s>", function() vim.lsp.buf.signature_help() end, {desc = "Signature Help"})
vim.keymap.set("n", "<leader>cv", function() vim.lsp.buf.hover() end, {desc = "View Value under Cursor"})
vim.keymap.set("n", "<leader>cr", function() vim.lsp.buf.rename() end, {desc = "Rename..."})
vim.keymap.set("n", "<leader>cq", ":lua require'telescope.builtin'.quickfix()<CR>", {desc = "Show quickfix"})
vim.keymap.set("n", "<leader>cx", function() for _,client in ipairs(vim.lsp.buf_get_clients()) do require('workspace-diagnostics').populate_workspace_diagnostics(client,0) end end, {desc = "Populate diagnostics"})

-- (n) <leader>cf - format code
-- vim.keymap.set("n", "<leader>cf", ":FzfLua quickfix<CR>", {desc = "Quickfix List"})
-- vim.keymap.set("n")

-- Goto commands
vim.keymap.set("n", "<leader>gr", ":lua require'telescope.builtin'.lsp_references()<CR>", { desc = "Goto References" })
vim.keymap.set("n", "<leader>gd", ":lua require'telescope.builtin'.lsp_definitions()<CR>", { desc = "Goto Definitions" })
vim.keymap.set("n", "<leader>gi", ":lua require'telescope.builtin'.lsp_incoming_calls()<CR>", { desc = "Goto Incoming Calls" })
vim.keymap.set("n", "<leader>go", ":lua require'telescope.builtin'.lsp_outgoing_calls()<CR>", { desc = "Goto Outgoing calls" })
vim.keymap.set("n", "<leader>gs", ":lua require'telescope.builtin'.lsp_document_symbols()<CR>", { desc = "Goto Doc Symbols" })
vim.keymap.set("n", "<leader>gS", ":lua require'telescope.builtin'.lsp_workspace_symbols()<CR>", { desc = "Goto ALL Symbols" })


-- Find commands
vim.keymap.set("n", "<leader>ff", ':lua require"telescope.builtin".current_buffer_fuzzy_find()<CR>', { desc = "Find in File" })
vim.keymap.set("n", "<leader>fg", ':lua require"telescope.builtin".live_grep()<CR>', {desc = "Find Everywhere"})

vim.keymap.set("n", "<leader>fr", ":GrugFar<CR>", { desc = "Find/Replace" })
-- (n) <leader>j - flash (acejump)
vim.keymap.set("n", "<leader>fF", ":lua require'telescope.builtin'.find_files()<CR>", { desc = "Find Files" })

-- Debug commands
vim.keymap.set("n", "<leader>du", ":lua require'dapui'.toggle()<CR>", { desc = "toggle debug UI" })
vim.keymap.set("n", "<leader>d?", ":lua require'telescope'.extensions.dap.commands()<CR>", { desc = "See Debug Cmds" })
vim.keymap.set("n", "<leader>ds", ":lua require'telescope'.extensions.dap.configurations()<CR>", { desc = "Start Debug" })
vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>", { desc = "Breakpoint" })
vim.keymap.set("n", "<leader>dc", ":DapContinue<CR>", { desc = "Start/Continue" })
vim.keymap.set("n", "<leader>dx", ":DapTerminate<CR>", { desc = "Stop" })
vim.keymap.set("n", "<leader>do", ":DapStepOver<CR>", { desc = "Step Over" })
vim.keymap.set("n", "<leader>d>", ":DapStepInto<CR>", { desc = "Step Into" })
vim.keymap.set("n", "<leader>d<", ":DapStepOut<CR>", { desc = "Step Out" })
vim.keymap.set("n", "<F5>", ":DapContinue<CR>", { desc = "(DBG) Start/Continue" })
vim.keymap.set("n", "<F6>", ":DapTerminate<CR>", { desc = "(DBG) Stop" })
vim.keymap.set("n", "<F9>", ":DapStepOver<CR>", { desc = "(DBG) Step Over" })
vim.keymap.set("n", "<F7>", ":DapStepInto<CR>", { desc = "(DBG) Step Into" })
vim.keymap.set("n", "<F8>", ":DapStepOut<CR>", { desc = "(DBG) Step Out" })
vim.keymap.set({ "n", "v" }, "<F11>", ":lua require('dapui').eval()<CR>:lua require('dapui').eval<CR>",
  { desc = "Eval Cursor" })
vim.keymap.set({ "n", "v" }, "<leader>de", ":lua require('dapui').eval()<CR>:lua require('dapui').eval<CR>",
  { desc = "Eval Cursor" })
