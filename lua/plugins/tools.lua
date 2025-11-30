-- lua/plugins/tools.lua
return {
  -- 1. Which-Key – LazyVim-style (right side, icons + full descs always)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      preset = "helix",
      delay = 0,
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = " ",
        mappings = true,
      },
      win = {
        border = "rounded",
        padding = { 1, 2 },
        wo = { winblend = 10 },
      },
      layout = { align = "center", spacing = 4 },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      wk.add({
        -- Main groups
        { "<leader>e",  group = " Explorer / Files" },
        { "<leader>bf", desc = "Buffers (float)",           icon = "" },
        { "<leader>c",  group = " Code / Todo" },
        { "<leader>cs", desc = "Code Outline (Aerial)",     icon = "" },
        { "<leader>ct", desc = "List Todos",                icon = "" },
        { "<leader>d",  group = "󰃤 Debug" },
        { "<leader>g",  group = "󰊢 Git" },
        { "<leader>l",  desc = "Lazy (Plugins)",            icon = "󰒲" },
        { "<leader>n",  desc = "New File/Project",          icon = "" },
        { "<leader>q",  desc = "Quit",                      icon = "󰗼" },
        { "<leader>w",  desc = "Write (Save)",              icon = "" },
        { "<leader>y",  desc = "Yank History",              icon = "󰅌" },
        { "<leader>u",  desc = "Undo Tree",                 icon = "" },

        -- Optional: show these even if not mapped yet (so they never appear blank)
        { "<leader>a",  desc = "Harpoon Add Mark",          icon = "󰛢" },
        { "<leader>r",  desc = "Recent Files",              icon = "󰋚" },
        { "<leader>f",  group = "Find / Telescope" },
      })
    end,
  },

  -- 2. Neo-tree – File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        filesystem = {
          filtered_items = { visible = true, hide_dotfiles = false },
          follow_current_file = { enabled = true },
        },
        buffers = { follow_current_file = { enabled = true } },
      })
      vim.keymap.set("n", "<leader>e",  ":Neotree filesystem reveal left toggle<CR>",  { desc = "File Explorer" })
      vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>",           { desc = "Buffer Explorer" })
    end,
  },

  -- 3. Aerial – Code outline on the right
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("aerial").setup({
        layout = { default_direction = "prefer_right" },
        on_attach = function(bufnr)
          vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
          vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        end,
      })
      vim.keymap.set("n", "<leader>cs", "<cmd>AerialToggle!<CR>", { desc = "Code Structure (Aerial)" })
    end,
  },

  -- 4. Yanky – Better yank/paste + history
  {
    "gbprod/yanky.nvim",
    config = function()
      require("yanky").setup({})
      vim.keymap.set({"n","x"}, "p",  "<Plug>(YankyPutAfter)")
      vim.keymap.set({"n","x"}, "P",  "<Plug>(YankyPutBefore)")
      vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
      vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
      vim.keymap.set("n", "<leader>y", ":Telescope yank_history<CR>", { desc = "Yank History" })
    end,
  },

  -- 5. Undotree
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undo Tree" })
    end,
  },

  -- 6. Todo Comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup()
      vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next Todo" })
      vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Prev Todo" })
      vim.keymap.set("n", "<leader>ct", ":TodoTelescope<CR>", { desc = "List Todos" })
    end,
  },
}
