-- lua/config/keymaps.lua
local map = vim.keymap.set

-- Basic Keymaps
map("n", "<leader>w", ":w<CR>")
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>l", ":Lazy<CR>")
map("n", "<C-_>", "gcc", { remap = true }) -- Comment toggle

-- === New file/project ===
map("n", "<leader>n", function()
  local path = vim.fn.input("New project/file: ", "", "file")
  if path == "" then return end
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":p:h"), "p")
  vim.cmd("edit " .. vim.fn.fnameescape(path))
  vim.cmd("cd " .. vim.fn.fnameescape(vim.fn.fnamemodify(path, ":p:h")))
end)

-- === Config Shortcuts ===
map("n", "<leader>vc", function()
  -- Opens the Neovim config directory
  vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
  vim.cmd("cd " .. vim.fn.stdpath("config"))
end, { desc = "Edit Config" })
