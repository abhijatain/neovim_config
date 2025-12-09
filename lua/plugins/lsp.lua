-- lua/plugins/lsp.lua
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Safely add cmp-nvim-lsp capabilities if installed
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
	capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
end

-- Common on_attach for keymaps
local on_attach = function(client, bufnr)
	local bufmap = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
	end

	bufmap("n", "gd", vim.lsp.buf.definition, "Goto Definition")
	bufmap("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
	bufmap("n", "gr", vim.lsp.buf.references, "References")
	bufmap("n", "gi", vim.lsp.buf.implementation, "Implementation")
	bufmap("n", "K", vim.lsp.buf.hover, "Hover")
	bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
	bufmap("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
	bufmap("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
	bufmap("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
end

return {
	{ "williamboman/mason.nvim", config = true },

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			ensure_installed = {
				"intelephense",
				"lua_ls",
				"pyright",
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"emmet_ls",
			},
			handlers = {
				-- Default handler for all servers
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end,

				-- Lua
				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
								workspace = { checkThirdParty = false },
								telemetry = { enable = false },
							},
						},
					})
				end,

				-- PHP
				["intelephense"] = function()
					require("lspconfig").intelephense.setup({
						capabilities = capabilities,
						on_attach = on_attach,
						filetypes = { "php", "blade" },
						settings = {
							intelephense = {
								files = { maxSize = 10000000 },
								environment = { phpVersion = "8.3.0" },
							},
						},
					})
				end,
			},
		},
	},

	{ "neovim/nvim-lspconfig" },
}
