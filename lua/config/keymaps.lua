-- lua/config/keymaps.lua
local map = vim.keymap.set

-- Set options for keymap groups (e.g., Which-key delay)
vim.o.timeout = true
vim.o.timeoutlen = 300

-- --- Basic Keymaps ---
map("n", "<leader>w", ":w<CR>", { desc = "Write (Save)" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>l", ":Lazy<CR>", { desc = "Lazy (Plugins)" })
map("n", "<C-_>", "gcc", { remap = true, desc = "Comment Toggle" })
map("n", "<leader>D", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show Diagnostics" })

-- === File Explorer (Neo-tree) ===
-- These are usually defined in the Neo-tree config file, but are added here for completeness
map("n", "<leader>e", ":Neotree filesystem reveal left toggle<CR>", { desc = "File Explorer" })
map("n", "<leader>bf", ":Neotree buffers reveal float<CR>", { desc = "Buffer Explorer" })

-- === New file/project ===
map("n", "<leader>n", function()
	local path = vim.fn.input("New project/file: ", "", "file")
	if path == "" then
		return
	end
	vim.fn.mkdir(vim.fn.fnamemodify(path, ":p:h"), "p")
	vim.cmd("edit " .. vim.fn.fnameescape(path))
	vim.cmd("cd " .. vim.fn.fnameescape(vim.fn.fnamemodify(path, ":p:h")))
end, { desc = "New File/Project" })

-- === Config Shortcuts ===
map("n", "<leader>vc", function()
	-- Opens the Neovim config directory
	vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
	vim.cmd("cd " .. vim.fn.stdpath("config"))
end, { desc = "Edit Config (init.lua)" })
