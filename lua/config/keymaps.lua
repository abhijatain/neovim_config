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

-- --- LSP (Language Server Protocol) Keymaps ---
-- NOTE: The 'desc' field is vital for Which-Key!
map({ "n", "v" }, "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code Action" })
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename Symbol" })
map("n", "<leader>D", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show Diagnostics" })

-- Standard navigation keymaps
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to Definition" })
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Go to Declaration" })
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Show References" })
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Show Documentation" })

-- Diagnostic navigation (uses standard nvim diagnostic functions)
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Previous Diagnostic" })
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Next Diagnostic" })
map("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "LSP Info" })
