-- lua/plugins/formatting.lua
return {
	-- ========================================
	-- 1. Formatting with conform.nvim (2025 best practice)
	-- ========================================
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- Format on save (super smooth in 2025)
			format_on_save = {
				timeout_ms = 1000,
				lsp_fallback = true,
			},

			formatters_by_ft = {
				-- PHP & Laravel
				php = { "pint" }, -- Laravel Pint = official formatter 2025
				blade = { "pint" }, -- Works perfectly on .blade.php too

				-- JavaScript / Frontend
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },
				vue = { "prettierd" },
				svelte = { "prettierd" },
				css = { "prettierd" },
				scss = { "prettierd" },
				html = { "prettierd" },
				json = { "prettierd" },
				jsonc = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
				graphql = { "prettierd" },

				-- Others
				lua = { "stylua" },
				python = { "isort", "black" },
			},

			formatters = {
				-- Laravel Pint (installed via Composer)
				pint = {
					command = "vendor/bin/pint",
					args = { "--no-interaction" },
					stdin = true,
				},

				-- Prettier daemon (fast!)
				prettierd = {
					require_cwd = false,
				},

				stylua = {
					require_cwd = false,
				},

				black = { require_cwd = false },
				isort = { require_cwd = false },
			},
		},

		config = function(_, opts)
			require("conform").setup(opts)

			-- Keymap "<leader>cf" to format file/selection
			vim.keymap.set({ "n", "v" }, "<leader>cf", function()
				require("conform").format({ lsp_fallback = true, timeout_ms = 1000 })
			end, { desc = "[C]ode [F]ormat" })

			-- Show which formatter was used
			vim.keymap.set("n", "<leader>cF", function()
				vim.cmd.ConformInfo()
			end, { desc = "[C]ode [F]ormatter Info" })
		end,
	},

	-- ========================================
	-- 2. Linting with nvim-lint (only for JS/TS/Python)
	-- For PHP → Intelephense already does perfect linting/diagnostics
	-- ========================================
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				vue = { "eslint_d" },
				svelte = { "eslint_d" },
				python = { "ruff" },
				-- PHP: DO NOT add phpstan/psalm here → Intelephense is 10× faster and better
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>cl", function()
				lint.try_lint()
			end, { desc = "[C]ode [L]int" })
		end,
	},
}
