-- lua/plugins/ui.lua
return {
  -- Catppuccin Theme
  { 
    "catppuccin/nvim", 
    name = "catppuccin", 
    priority = 1000, 
    config = function()
      require("catppuccin").setup({ flavour = "mocha" })
      vim.cmd.colorscheme("catppuccin")
    end 
  },

  -- Mini.nvim Suite
  { "echasnovski/mini.pairs", version = false, config = function() require("mini.pairs").setup() end },
  { "echasnovski/mini.comment", version = false, config = function() require("mini.comment").setup() end },
  { "echasnovski/mini.indentscope", version = false, config = function() require("mini.indentscope").setup({ symbol = "│" }) end },
  { "echasnovski/mini.completion", version = false, config = function() require("mini.completion").setup() end },
 { "echasnovski/mini.icons", version = false, config = function() require("mini.icons").setup() end }, 
  -- Mini.surround with custom keymaps
  { 
    "echasnovski/mini.surround", 
    version = false, 
    config = function() 
      require("mini.surround").setup() 
      -- Mappings defined inside config to keep it modular
      vim.keymap.set("n", '<leader>s"', 'viwsa"', { remap = true })
      vim.keymap.set("n", "<leader>s'", "viwsa'", { remap = true })
      vim.keymap.set("n", "<leader>s(", "viwsa(", { remap = true })
      vim.keymap.set("n", "<leader>s[", "viwsa[", { remap = true })
      vim.keymap.set("n", "<leader>s{", "viwsa{", { remap = true })
      vim.keymap.set("n", "<leader>s<", "viwsa<", { remap = true })
      vim.keymap.set("v", "<leader>s", "<Plug>(mini.surround-add)", { remap = true })
    end 
  },
}

