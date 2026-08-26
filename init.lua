--
-- V I M    O P T I O N S
--

vim.g.is_windows = vim.fn.has("win32") == 1
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.wrap = false

vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "auto"
vim.opt.foldmethod = "expr"

vim.opt.background = "dark"

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

-- allow copying to system clipboard, even over SSH
vim.g.clipboard = "osc52"
vim.g.clipboard = {
	name = "OSC 52",
	copy = {
		["+"] = require("vim.ui.clipboard.osc52").copy("+"),
		["*"] = require("vim.ui.clipboard.osc52").copy("*"),
	},
	paste = {
		["+"] = function() end, -- Pasting disabled
		["*"] = function() end, -- Pasting disabled
	},
}

-- enable "super backspace"
vim.opt.backspace = { "indent", "eol", "start" }
vim.keymap.set("i", "<BS>", function()
	local col = vim.fn.col(".") - 1
	local line = vim.fn.getline(".")
	local before_cursor = line:sub(1, col)

	if before_cursor:match("^%s+$") then
		return "<C-u><BS>"
	else
		return "<BS>"
	end
end, { expr = true, noremap = true })

-- update cwd when opening folder from cmdline
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local path = vim.fn.expand("%:p:h")
		if vim.fn.isdirectory(path) == 1 then
			vim.cmd("cd " .. path)
		end
	end,
})

--
-- !!!!   I N I T   L A Z Y . N V I M   P L U G I N S !!!!
--                ( also init colorscheme )
--

require("config.lazy")
vim.cmd.colorscheme("molokai")

--
-- L S P   A N D   D I A G N O S T I C S
--

-- handle treesitter vs lsp folding

vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client:supports_method("textDocument/foldingRange") then
			vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end,
})

-- disable underlines for info/hints
vim.diagnostic.config({
	virtual_text = false,
	underline = {
		severity = {
			min = vim.diagnostic.severity.WARN,
		},
	},
})

-- configure LSPs
vim.lsp.config("html", {
	filetypes = { "html", "razor" },
})

-- enable LSPs

vim.lsp.enable("html")
vim.lsp.enable("jsonls")
vim.lsp.enable("marksman")

-- vim.lsp.enable('roslyn_ls')

vim.lsp.enable("stylua")

vim.lsp.enable("ts_ls")
-- vim.lsp.enable('tsgo')

--
-- D E B U G G I N G
--

-- set breakpoint colors
local set_namespace = vim.api.nvim__set_hl_ns or vim.api.nvim_set_hl_ns
local namespace = vim.api.nvim_create_namespace("dap-hlng")
vim.api.nvim_set_hl(namespace, "DapBreakpoint", { fg = "#eaeaeb", bg = "#ffffff" })
vim.api.nvim_set_hl(namespace, "DapLogPoint", { fg = "#eaeaeb", bg = "#ffffff" })
vim.api.nvim_set_hl(namespace, "DapStopped", { fg = "#eaeaeb", bg = "#ffffff" })

-- set breakpoint icons
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

-- skeletons
vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = { "tasks.json" },
	callback = function()
		vim.cmd("silent! 0r $XDG_CONFIG_HOME/template/skeletons/tasks.json")
	end,
})

-- fix claude window
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		local bufname = vim.api.nvim_buf_get_name(0)
		if bufname:match("claude") then
			vim.opt_local.buflisted = false
		end
	end,
})

--
-- C U S T O M   K E Y B I N D I N G S
--

--
--   TOP-LEVEL KEYBINDS
--

-- double-tap escape exits terminal cursor lock
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

-- esc clears any stuck noice elements
vim.keymap.set("n", "<Esc>", function()
	vim.cmd("nohlsearch")
	require("noice").cmd("dismiss")
end, { silent = true })

-- navigation and pane sizing
vim.keymap.set("n", "<Tab>", ":bn<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-Tab>", ":bp<CR>", { desc = "Prev Buffer" })

vim.keymap.set("n", "<leader><Tab>", "<C-w>w", { desc = "Next Window" })
vim.keymap.set("n", "<leader><S-Tab>", "<C-w>W", { desc = "Prev Window" })

vim.keymap.set("n", "<C-Down>", "<C-w>-", { desc = "+ Win Height" })
vim.keymap.set("n", "<C-Up>", "<C-w>+", { desc = "- Win Height" })
vim.keymap.set("n", "<C-Left>", "<C-w><", { desc = "+ Win Width" })
vim.keymap.set("n", "<C-Right>", "<C-w>>", { desc = "- Win Width" })

vim.keymap.set("n", "<C-t>", ":MaximizerToggle<CR>", { desc = "Fullscreen Current Window" })

-- Toggle "tool panes"
vim.keymap.set("n", "<F2>", ":Neotree toggle=true<CR>", { desc = "Toggle Filetree" })

vim.keymap.set("n", "<F3>", "<CMD>lua require'FTerm'.toggle()<CR>", { desc = "Toggle Terminal" })
vim.keymap.set("t", "<F3>", "<C-\\><c-n><CMD>lua require'FTerm'.toggle()<CR>", { desc = "Toggle Terminal" })

vim.keymap.set("n", "<F4>", ":OverseerRun<CR>", { desc = "Run Task..." })
vim.keymap.set("n", "<F16>", ":OverseerToggle<CR>", { desc = "Show Running Tasks" })
vim.keymap.set("n", "<S-F4>", ":OverseerToggle<CR>", { desc = "Show Running Tasks" })

-- better buffer closing keystrokes
vim.keymap.set("n", "<leader>w", function()
	require("mini.bufremove").delete()
end, { desc = "Close Buffer" })
vim.keymap.set("n", "<leader>W", function()
	require("mini.bufremove").delete(0, true)
end, { desc = "Force Close Buffer" })

-- Debugger basic commands
vim.keymap.set("n", "<F5>", ":DapContinue<CR>", { desc = "(DBG) Start/Continue" })
vim.keymap.set("n", "<F6>", ":DapStepOut<CR>", { desc = "(DBG) Step Out" })
vim.keymap.set("n", "<F7>", ":DapStepOver<CR>", { desc = "(DBG) Step Over" })
vim.keymap.set("n", "<F8>", ":DapStepInto<CR>", { desc = "(DBG) Step Into" })
vim.keymap.set("n", "<F9>", ":DapToggleBreakpoint<CR>", { desc = "(DBG) Toggle Breakpoint" })
vim.keymap.set("n", "<F10>", ":DapViewToggle<CR>", { desc = "(DBG) Toggle Debug UI" })

--
--   MENU KEYBINDS
--

-- Code Completion
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
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ lsp_fallback = true, async = true, timeout_ms = 1500 })
end, { desc = "Format" })
vim.keymap.set("n", "<leader>cj", ":%!jq .<CR>", { desc = "Format JSON" })
vim.keymap.set("n", "<leader>ct", ":%!jq .<CR>", { desc = "Format JSON" })

-- AI command
-- vim.keymap.set("n", "<leader>ai", ":Pairup toggle<CR>", { desc = "Toggle Pairup AI" })
vim.keymap.set("n", "<leader>ac", ":CodeCompanionChat toggle<CR>", { desc = "Toggle AI Chat" })
vim.keymap.set("n", "<leader>ai", ":CodeCompanion<CR>", { desc = "Inline AI query" })

-- Search and replace
vim.keymap.set("n", "<leader>ff", ':lua require"telescope.builtin".buffers()<CR>', { desc = "Find open buffer" })
vim.keymap.set("n", "<leader>fg", ':lua require"telescope.builtin".live_grep()<CR>', { desc = "Find Everywhere" })
vim.keymap.set("n", "<leader>fr", ":GrugFar<CR>", { desc = "Find/Replace" })
vim.keymap.set("n", "<leader>fF", ":lua require'telescope.builtin'.find_files()<CR>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fc", ":lua require'telescope.builtin'.git_status()<CR>", { desc = "Find Changed Files" })
vim.keymap.set(
	"x",
	"<leader>fy",
	'"zy<Cmd>lua require("telescope.builtin").grep_string({ search = vim.fn.getreg("z") })<CR>',
	{ silent = true, desc = "find selection" }
)
-- !!! (n) <leader>j - flash (acejump) - defined elsewhere, listed here for completeness

-- LSP Go-to functions
vim.keymap.set("n", "<leader>gd", ":lua vim.lsp.buf.definition()<CR>", { desc = "Goto Definition" })
vim.keymap.set("n", "<leader>gD", ":lua vim.lsp.buf.type_definition()<CR>", { desc = "Goto TypeDef" })
vim.keymap.set(
	"n",
	"<leader>gi",
	":lua require'telescope.builtin'.lsp_incoming_calls()<CR>",
	{ desc = "Goto Incoming Calls" }
)
vim.keymap.set(
	"n",
	"<leader>go",
	":lua require'telescope.builtin'.lsp_incoming_calls()<CR>",
	{ desc = "Goto Outgoing Calls" }
)
vim.keymap.set("n", "<leader>gu", ":lua require'telescope.builtin'.lsp_references()<CR>", { desc = "Goto Usages" })

-- Debugger advanced commands
vim.keymap.set("n", "<leader>d?", ":lua require'telescope'.extensions.dap.commands()<CR>", { desc = "See Debug Cmds" })
vim.keymap.set("n", "<leader>dx", ":DapTerminate<CR>", { desc = "Stop" })
vim.keymap.set({ "n", "v" }, "<leader>de", ":lua require('dapui').eval()<CR>", { desc = "Eval Cursor" })
vim.keymap.set("n", "<leader>dr", ":JdtUpdateHotcode<CR>", { desc = "Hot Reload" })

-- Neotest Test Runner commands
vim.keymap.set("n", "<leader>ta", ":lua require('neotest').run.attach()<CR>", { desc = "Attach" })
vim.keymap.set("n", "<leader>tx", ":lua require('neotest').run.stop()<CR>", { desc = "Terminate" })
vim.keymap.set("n", "<leader>ts", ":lua require('neotest').summary.toggle()<CR>", { desc = "Toggle summary" })
vim.keymap.set("n", "<leader>to", ":lua require('neotest').output_panel.toggle()<CR>", { desc = "Toggle output panel" })
vim.keymap.set("n", "<leader>tt", ":lua require('neotest').run.run()<CR>", { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tT", ":lua require('neotest').run.run({suite = true})<CR>", { desc = "Run test suite" })

-- Navigation commands
-- vim.keymap.set("n", "<leader>[", ":lua vim.diagnostic.goto_prev()<CR>", { desc = "Previous Error" })
-- vim.keymap.set("n", "<leader>]", ":lua vim.diagnostic.goto_next()<CR>", { desc = "Next Error" })
vim.keymap.set("n", "[", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous TODO" })
vim.keymap.set("n", "]", function()
	require("todo-comments").jump_next()
end, { desc = "Next TODO" })

--
--   CUSTOM TEXT OBJECTS
--

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
vim.keymap.set({ "n", "x", "o" }, "[c", function()
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
