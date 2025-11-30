-- lua/plugins/lsp.lua

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
		-- This 'config' block now only defines the on_attach function
		config = function()
			-- --- 1. The ON_ATTACH function ---
			-- This runs every time an LSP server successfully starts
			-- It sets up buffer-local keymaps for diagnostics
			local on_attach = function(client, bufnr)
				vim.cmd.LspInfo()
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Prev Diagnostic" })
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next Diagnostic" })
			end

			-- Store on_attach globally so the opts table can access it
			vim.g.on_attach = on_attach
		end,
	},

	-- Configuration for mason-lspconfig.nvim
	-- This block will now handle starting the LSPs
	{
		"williamboman/mason-lspconfig.nvim",
		-- Use the opts table for configuration
		opts = {
			-- Pass the setup handlers here instead of inside the config function
			handlers = {
				-- Default setup for all servers installed via Mason
				function(server_name)
					require("lspconfig")[server_name].setup({
						on_attach = vim.g.on_attach, -- Use the global on_attach function
						capabilities = vim.lsp.protocol.make_client_capabilities(),
					})
				end,

				-- Custom Setup: Clangd (C/C++)
				["clangd"] = function()
					require("lspconfig").clangd.setup({
						on_attach = vim.g.on_attach,
						cmd = { "clangd", "--background-index" },
					})
				end,

				-- Custom Setup: Pyright (Python)
				["pyright"] = function()
					require("lspconfig").pyright.setup({
						on_attach = vim.g.on_attach,
						settings = {
							python = {
								analysis = {
									useLibraryCodeForTypes = true,
								},
							},
						},
					})
				end,
			},
		},
	},
}
