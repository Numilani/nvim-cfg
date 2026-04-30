vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.clipboard = "osc52"

function no_paste(reg)
	return function(lines)
		-- Do nothing! We can't paste with OSC52
	end
end

vim.g.clipboard = {
	name = "OSC 52",
	copy = {
		["+"] = require("vim.ui.clipboard.osc52").copy("+"),
		["*"] = require("vim.ui.clipboard.osc52").copy("*"),
	},
	paste = {
		["+"] = no_paste("+"), -- Pasting disabled
		["*"] = no_paste("*"), -- Pasting disabled
	},
}

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

vim.opt.background = "dark"

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
vim.api.nvim_set_hl(namespace, "DapBreakpoint", { fg = "#eaeaeb", bg = "#ffffff" })
vim.api.nvim_set_hl(namespace, "DapLogPoint", { fg = "#eaeaeb", bg = "#ffffff" })
vim.api.nvim_set_hl(namespace, "DapStopped", { fg = "#eaeaeb", bg = "#ffffff" })

vim.fn.sign_define("DapBreakpoint", {
	text = "•",
	texthl = "DapBreakpoint",
	linehl = "DapBreakpoint",
	numhl = "DapBreakpoint",
})
vim.fn.sign_define(
	"DapBreakpointCondition",
	{ text = "•", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapBreakpointRejected",
	{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapLogPoint",
	{ text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
)
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

require("config.lazy")
-- vim.cmd("colorscheme PaperColor")
vim.cmd.colorscheme("molokai")

-- skeletons
vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = { "tasks.json" },
	callback = function()
		vim.cmd("silent! 0r $XDG_CONFIG_HOME/template/skeletons/tasks.json")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "dapui_*",
	callback = function()
		vim.opt_local.winfixwidth = true
		vim.opt_local.winfixheight = true
	end,
})
vim.api.nvim_create_autocmd("BufDelete", {
	callback = function()
		require("dapui").close()
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		local bufname = vim.api.nvim_buf_get_name(0)
		if bufname:match("claude") then
			vim.opt_local.buflisted = false
		end
	end,
})

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

-- UI commands
vim.keymap.set("n", "<leader>w", function()
	require("mini.bufremove").delete()
end, { desc = "Close Buffer" })
vim.keymap.set("n", "<leader>W", function()
	require("mini.bufremove").delete(0, true)
end, { desc = "Force Close Buffer" })
-- vim.keymap.set("n", "<leader>e", ":Neotree toggle=true<CR>", { desc = "Toggle Filetree" })
vim.keymap.set("n", "<F2>", ":Neotree toggle=true<CR>", { desc = "Toggle Filetree" })
vim.keymap.set("n", "<Tab>", ":bn<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-Tab>", ":bp<CR>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<leader><Tab>", "<C-w>w", { desc = "Next Window" })
vim.keymap.set("n", "<leader><S-Tab>", "<C-w>W", { desc = "Prev Window" })
vim.keymap.set("n", "<C-Down>", "<C-w>-", { desc = "+ Win Height" })
vim.keymap.set("n", "<C-Up>", "<C-w>+", { desc = "- Win Height" })
vim.keymap.set("n", "<C-Left>", "<C-w><", { desc = "+ Win Width" })
vim.keymap.set("n", "<C-Right>", "<C-w>>", { desc = "- Win Width" })
-- vim.keymap.set("n", "<F3>", ":MaximizerToggle<CR>", { desc = "Fullscreen Current Window" })
vim.keymap.set("n", "<C-t>", ":MaximizerToggle<CR>", { desc = "Fullscreen Current Window" })

-- vim.keymap.set('n', '<C-t>', "<CMD>lua require'FTerm'.toggle()<CR>", { desc = "Toggle Terminal" })
-- vim.keymap.set('t', '<C-t>', "<C-\\><c-n><CMD>lua require'FTerm'.toggle()<CR>", { desc = "Toggle Terminal" })
vim.keymap.set("n", "<F3>", "<CMD>lua require'FTerm'.toggle()<CR>", { desc = "Toggle Terminal" })
vim.keymap.set("t", "<F3>", "<C-\\><c-n><CMD>lua require'FTerm'.toggle()<CR>", { desc = "Toggle Terminal" })

-- Action commands
-- vim.keymap.set("n", "<leader>ct", ":OverseerRun<CR>", { desc = "Run Task..." })
vim.keymap.set("n", "<F4>", ":OverseerRun<CR>", { desc = "Run Task..." })

-- Code commands
vim.keymap.set({ "n", "v" }, "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>", { desc = "Code Actions" })
vim.keymap.set({ "n", "i" }, "<C-p>", function()
	vim.lsp.buf.signature_help()
end, { desc = "Parameter Info" })
vim.keymap.set("n", "<leader>cr", function()
	vim.lsp.buf.rename()
end, { desc = "Rename..." })
vim.keymap.set("n", "<leader>cv", function()
	vim.lsp.buf.hover()
end, { desc = "Hover Info" })

-- vim.keymap.set("n", "<leader>cx",
--   function()
--     for _, client in ipairs(vim.lsp.buf_get_clients()) do
--       require('workspace-diagnostics')
--           .populate_workspace_diagnostics(client, 0)
--     end
--   end, { desc = "Populate diagnostics" })

-- Find commands
vim.keymap.set(
	"n",
	"<leader>ff",
	':lua require"telescope.builtin".current_buffer_fuzzy_find()<CR>',
	{ desc = "Find in File" }
)
vim.keymap.set("n", "<leader>fg", ':lua require"telescope.builtin".live_grep()<CR>', { desc = "Find Everywhere" })

vim.keymap.set("n", "<leader>fr", ":GrugFar<CR>", { desc = "Find/Replace" })
-- (n) <leader>j - flash (acejump)
vim.keymap.set("n", "<leader>fF", ":lua require'telescope.builtin'.find_files()<CR>", { desc = "Find Files" })

-- Debug commands
-- vim.keymap.set("n", "<leader>du", ":DapViewToggle<CR>", { desc = "toggle debug UI" })
vim.keymap.set("n", "<leader>d?", ":lua require'telescope'.extensions.dap.commands()<CR>", { desc = "See Debug Cmds" })
vim.keymap.set(
	"n",
	"<leader>ds",
	":lua require'telescope'.extensions.dap.configurations()<CR>",
	{ desc = "Start Debug" }
)
-- vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>", { desc = "Breakpoint" })
-- vim.keymap.set("n", "<leader>dc", ":DapContinue<CR>", { desc = "Start/Continue" })
vim.keymap.set("n", "<leader>dx", ":DapTerminate<CR>", { desc = "Stop" })
-- vim.keymap.set("n", "<leader>do", ":DapStepOver<CR>", { desc = "Step Over" })
-- vim.keymap.set("n", "<leader>d>", ":DapStepInto<CR>", { desc = "Step Into" })
-- vim.keymap.set("n", "<leader>d<", ":DapStepOut<CR>", { desc = "Step Out" })
vim.keymap.set(
	{ "n", "v" },
	"<leader>de",
	":lua require('dapui').eval()<CR>:lua require('dapui').eval<CR>",
	{ desc = "Eval Cursor" }
)
vim.keymap.set("n", "<F5>", ":DapContinue<CR>", { desc = "(DBG) Start/Continue" })
vim.keymap.set("n", "<F6>", ":DapStepOut<CR>", { desc = "(DBG) Step Out" })
vim.keymap.set("n", "<F7>", ":DapStepOver<CR>", { desc = "(DBG) Step Over" })
vim.keymap.set("n", "<F8>", ":DapStepInto<CR>", { desc = "(DBG) Step Into" })
vim.keymap.set("n", "<F9>", ":DapToggleBreakpoint<CR>", { desc = "(DBG) Toggle Breakpoint" })
vim.keymap.set("n", "<F10>", ":DapViewToggle<CR>", { desc = "(DBG) Toggle Debug UI" })

vim.keymap.set("n", "<leader>ta", ":lua require('neotest').run.attach()<CR>", { desc = "Attach" })
vim.keymap.set("n", "<leader>tx", ":lua require('neotest').run.stop()<CR>", { desc = "Terminate" })
vim.keymap.set("n", "<leader>ts", ":lua require('neotest').summary.toggle()<CR>", { desc = "Toggle summary" })
vim.keymap.set("n", "<leader>to", ":lua require('neotest').output_panel.toggle()<CR>", { desc = "Toggle output panel" })
vim.keymap.set("n", "<leader>tt", ":lua require('neotest').run.run()<CR>", { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tT", ":lua require('neotest').run.run({suite = true})<CR>", { desc = "Run test suite" })

vim.keymap.set("n", "<leader>[", ":lua vim.diagnostic.goto_prev()<CR>", { desc = "Previous Error" })
vim.keymap.set("n", "<leader>]", ":lua vim.diagnostic.goto_next()<CR>", { desc = "Next Error" })

vim.keymap.set("n", "<leader>dr", ":JdtUpdateHotcode<CR>", { desc = "Hot Reload" })

-- custom textobject motions

-- selection motions (defaults)
vim.keymap.set({ "x", "o" }, "af", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
end)

-- added 4/30
vim.keymap.set({ "x", "o" }, "aa", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@local.definition.parameter", "locals")
end)

-- movement motions (defaults)
vim.keymap.set({ "n", "x", "o" }, "]f", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[f", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "]o", function()
	require("nvim-treesitter-textobjects.move").goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "]c", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
end)
vim.keymap.set({ "n", "x", "o" }, "]c", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@local.scope", "locals")
end)

-- added 4/30
vim.keymap.set({ "n", "x", "o" }, "]?", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@keyword.conditional", "textobjects")
end)

-- vim.keymap.set({ "n", "x", "o" }, "]M", function()
-- 	require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
-- end)
-- vim.keymap.set({ "n", "x", "o" }, "[M", function()
-- 	require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
-- end)

