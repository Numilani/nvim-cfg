--
-- C U S T O M   K E Y B I N D I N G S
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

-- better buffer closing keystrokes
vim.keymap.set("n", "<leader>w", function()
	require("mini.bufremove").delete()
end, { desc = "Close Buffer" })
vim.keymap.set("n", "<leader>W", function()
	require("mini.bufremove").delete(0, true)
end, { desc = "Force Close Buffer" })

-- keybinds for baked-in LSP commands
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

-- a quick script for reformatting pasted JSON. Great for quickly reading OTEL logs!
vim.keymap.set("n", "<leader>cj", ":%!jq .<CR>", { desc = "Format JSON" })
vim.keymap.set("n", "<leader>ct", ":%!jq .<CR>", { desc = "Format JSON" })

-- specific key for JDTLS
vim.keymap.set("n", "<leader>dr", ":JdtUpdateHotcode<CR>", { desc = "Hot Reload" })
