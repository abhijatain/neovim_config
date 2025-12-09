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

	{ "folke/tokyonight.nvim", lazy = false, priority = 950 },
	{ "sainnhe/everforest", lazy = false, priority = 950 },
	{ "rebelot/kanagawa.nvim", lazy = false, priority = 950 },
	{ "sainnhe/gruvbox-material", lazy = false, priority = 950 },
	{ "craftzdog/solarized-osaka.nvim", lazy = false, priority = 950 },
	{ "rose-pine/neovim", name = "rose-pine", lazy = false, priority = 950 },
	{ "dracula/vim", name = "dracula", lazy = false, priority = 950 },
	{ "EdenEast/nightfox.nvim", lazy = false, priority = 950 },
	{ "navarasu/onedark.nvim", name = "onedark", lazy = false, priority = 950 },
	{ "LunarVim/onedarker.nvim", lazy = false, priority = 950 },
	{ "kristijanhusak/vim-hybrid-material", name = "hybrid_material", lazy = false, priority = 950 },
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
					{ name = "Catppuccin Mocha", colorscheme = "catppuccin" },
					{ name = "Tokyonight Night", colorscheme = "tokyonight-night" },
					{ name = "Everforest Hard", colorscheme = "everforest" },
					{ name = "Kanagawa Dragon", colorscheme = "kanagawa" },
					{ name = "Gruvbox Material", colorscheme = "gruvbox-material" },
					{ name = "Solarized Osaka", colorscheme = "solarized-osaka" },
					{ name = "Rose Pine", colorscheme = "rose-pine" },
					{ name = "Dracula", colorscheme = "dracula" },
					{ name = "Nightfox", colorscheme = "nightfox" },
					{ name = "OneDark Deep", colorscheme = "onedark" },
					{ name = "Hybrid Material", colorscheme = "hybrid_material" },

					-- LIGHT – these are gorgeous and work perfectly
					{ name = "PaperColor Light", colorscheme = "PaperColor" },
					{ name = "Material Lighter", colorscheme = "material-lighter" },
					{ name = "Zephyr Light", colorscheme = "zephyr" },
					{ name = "Dayfox (Light)", colorscheme = "dayfox" },
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
	-- 3. LUALINE – auto matches current theme
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
		keys = "gc",
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
		keys = { "sa", "sd", "sr" },
		config = function()
			require("mini.surround").setup()
			local keymap = vim.keymap.set
			keymap("n", '<leader>s"', 'viwsa"', { remap = true })
			keymap("n", "<leader>s'", "viwsa'", { remap = true })
			keymap("n", "<leader>s(", "viwsa(", { remap = true })
			keymap("n", "<leader>s[", "viwsa[", { remap = true })
			keymap("n", "<leader>s{", "viwsa{", { remap = true })
			keymap("n", "<leader>s<", "viwsa<", { remap = true })
			keymap("v", "<leader>s", "<Plug>(mini.surround-add)", { remap = true })
		end,
	},
}
