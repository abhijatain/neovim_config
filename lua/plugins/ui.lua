-- lua/plugins/ui.lua
return {
	-------------------------------------------------------------------
	-- 1. COLORSCHEIMES – ALL lazy=false so Themery persistence works
	-------------------------------------------------------------------
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = false,
				integrations = { mini = true, native_lsp = { enabled = true } },
			})
		end,
	},

	{ "scottmckendry/cyberdream.nvim", name = "cyberdream", lazy = false, priority = 950 },
	{ "nyoom-engineering/oxocarbon.nvim", name = "oxocarbon", lazy = false, priority = 950 },
	{ "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 950 },
	{ "folke/tokyonight.nvim", lazy = false, priority = 950 },
	{ "LunarVim/onedarker.nvim", lazy = false, priority = 950 },
	{ "NLKNguyen/papercolor-theme", name = "PaperColor", lazy = false, priority = 950 },

	-- LIGHT THEMES (beautiful & popular in 2025)
	{
		"marko-cerovac/material.nvim",
		lazy = false,
		priority = 950,
		config = function()
			require("material").setup({ style = "lighter" })
		end,
	},
	{ "glepnir/zephyr-nvim", lazy = false, priority = 950 }, -- soft light theme
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 950,
		config = function()
			require("nightfox").setup({ options = { transparent = false } })
		end,
	},

	-------------------------------------------------------------------
	-- 2. THEMERY – BULLETPROOF PERSISTENCE (2025 gold standard)
	-------------------------------------------------------------------
	{
		"zaldih/themery.nvim",
		priority = 1000,
		event = "UIEnter",
		config = function()
			require("themery").setup({
				themes = {
					-- DARK
					{ name = "Cyberdream", colorscheme = "cyberdream" },
					{ name = "Oxocarbon", colorscheme = "oxocarbon" },
					{ name = "Moonfly", colorscheme = "moonfly" },
					{ name = "Catppuccin Mocha", colorscheme = "catppuccin" },
					{ name = "Tokyonight Night", colorscheme = "tokyonight-night" },

					-- LIGHT – these are gorgeous and work perfectly
					{ name = "PaperColor Light", colorscheme = "PaperColor" },
					{ name = "Material Lighter", colorscheme = "material-lighter" },
					{ name = "Zephyr Light", colorscheme = "zephyr" },
					{ name = "Dayfox (Light)", colorscheme = "dayfox" },
					-- Original / Default (Revert option)
					{ name = "Nvim Default", colorscheme = "default" },
				},
				livePreview = true,
				makePersistent = true,

				-- THIS IS THE MAGIC that makes persistence 100% reliable
				themeLoader = function(theme)
					local plugin_map = {
						["tokyonight-night"] = "tokyonight",
						["solarized-flat"] = "solarized-flat.nvim",
						["material-lighter"] = "material.nvim",
						["dayfox"] = "nightfox.nvim",
					}
					local plugin = plugin_map[theme] or theme:gsub("-.*", "")
					require("lazy").load({ plugins = { plugin } })
					vim.schedule(function()
						vim.cmd.colorscheme(theme)
					end)
				end,
			})

			-- Fallback if something goes wrong (will never trigger normally)
			vim.schedule(function()
				if not vim.g.colors_name then
					vim.cmd.colorscheme("catppuccin")
				end
			end)
		end,
	},
	-------------------------------------------------------------------
	-- 3. LUALINE
	-------------------------------------------------------------------
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VimEnter",
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					icons_enabled = true,
					component_separators = { left = "│", right = "│" },
					section_separators = { left = "", right = "" },
				},
			})
		end,
	},

	-------------------------------------------------------------------
	-- 4. MINI.NVIM SUITE
	-------------------------------------------------------------------
	{
		"echasnovski/mini.pairs",
		version = false,
		event = "InsertEnter",
		config = function()
			require("mini.pairs").setup()
		end,
	},
	{
		"echasnovski/mini.comment",
		version = false,
		keys = { { "gc", mode = { "n", "v" } } },
		config = function()
			require("mini.comment").setup()
		end,
	},
	{
		"echasnovski/mini.indentscope",
		version = false,
		event = "BufReadPre",
		config = function()
			require("mini.indentscope").setup({ symbol = "│" })
		end,
	},
	{
		"echasnovski/mini.surround",
		version = false,
		event = "VeryLazy",
		config = function()
			require("mini.surround").setup({
				mappings = {
					add = "sa",
					delete = "sd",
					replace = "sr",
					find = "sf",
					find_left = "sF",
					highlight = "sh",
					update_n_lines = "sn",
					suffix_last = "l",
					suffix_next = "n",
				},
			})
			vim.keymap.set("x", "s", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
			vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
		end,
	},
}
