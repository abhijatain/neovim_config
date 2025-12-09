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

-- Inside your keymaps.lua – add these lines
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format file (Pint)" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action / Fix" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find References" })

-- Faster split navigation (Alt or Option key might also be used here)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })

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

map("n", "<leader>th", ":Themery<CR>", { desc = "UI: Theme Picker" })

-- Extra Telescope diagnostics keymaps (2025 muscle memory)
-- Telescope diagnostics – the ones you'll use 1000x
vim.keymap.set("n", "<leader>cdd", "<cmd>Telescope diagnostics<CR>", { desc = "All diagnostics (Telescope)" })
vim.keymap.set(
	"n",
	"<leader>cde",
	"<cmd>Telescope diagnostics bufnr=0<CR>",
	{ desc = "Current buffer diagnostics only" }
)
vim.keymap.set("n", "<leader>cdf", function()
	vim.diagnostic.open_float()
end, { desc = "Float diagnostic under cursor" })
