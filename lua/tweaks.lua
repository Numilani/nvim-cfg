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
