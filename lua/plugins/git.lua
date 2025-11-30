-- lua/plugins/git.lua
return {
  { "tpope/vim-rhubarb" },

  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = true,
  },

  {
    "tpope/vim-fugitive",
    config = function()
      local map = vim.keymap.set

      -- --- Fugitive Mappings ---
      map("n", "<leader>gg", ":Git<CR>",                        { desc = "Git status" })
      map("n", "<leader>gB", ":Telescope git_branches<CR>",     { desc = "Branches" })
      map("n", "<leader>gl", "<cmd>Telescope git_commits<CR>",  { desc = "All commits" })
      map("n", "<leader>gL", "<cmd>Telescope git_bcommits<CR>", { desc = "Buffer commits" })

      map("n", "<leader>ga", ":Git add %<CR>",                  { desc = "Add current file" })
      map("n", "<leader>gA", ":Git add .<CR>",                  { desc = "Add all" })
      map("n", "<leader>gc", ":Git commit<CR>",                 { desc = "Commit" })
      map("n", "<leader>gC", ":Git commit --amend<CR>",         { desc = "Commit --amend" })
      map("n", "<leader>gp", ":Git push<CR>",                   { desc = "Push" })
      map("n", "<leader>gP", ":Git push --force-with-lease<CR>",{ desc = "Push (safe force)" })
      map("n", "<leader>gf", ":Git fetch --prune<CR>",          { desc = "Fetch + prune" })
      map("n", "<leader>gF", ":Git pull --rebase<CR>",          { desc = "Pull --rebase" })

      map("n", "<leader>go", ":GBrowse<CR>",                    { desc = "Open on GitHub" })
      map("v", "<leader>go", ":'<,'>GBrowse<CR>",               { desc = "Open selection on GitHub" })
      map("n", "<leader>gO", ":GBrowse!<CR>",                   { desc = "Copy GitHub URL" })

      -- --- Custom Git Commands ---

      -- 1. Git Init
      vim.api.nvim_create_user_command("GitInit", function()
        local dir = vim.fn.expand("%:p:h")
        if dir == "" then dir = vim.fn.getcwd() end
        
        vim.system({ "git", "-C", dir, "init" }):wait()
        vim.system({ "git", "-C", dir, "add", "." }):wait()
        vim.system({ "git", "-C", dir, "commit", "-m", "Initial commit" }):wait()
        vim.notify("Initialized git repo in " .. dir, vim.log.levels.INFO)
      end, {})
      map("n", "<leader>gi", ":GitInit<CR>", { desc = "Git init + initial commit" })

      -- 2. Git Add Origin + Push
      vim.api.nvim_create_user_command("GitRemoteOrigin", function(opts)
        if #opts.fargs == 0 then return vim.notify("Need URL", vim.log.levels.ERROR) end
        local url = opts.fargs[1]

        vim.system({ "git", "remote", "add", "origin", url }):wait()
        vim.system({ "git", "branch", "-M", "main" }):wait()
        vim.system({ "git", "push", "-u", "origin", "main" }):wait()
        vim.notify("Origin -> " .. url .. " + first push done", vim.log.levels.INFO)
      end, { nargs = 1 })
      map("n", "<leader>gI", function()
        local url = vim.fn.input("Remote URL > ")
        if url ~= "" then vim.cmd("GitRemoteOrigin " .. url) end
      end, { desc = "Add origin + push first commit" })

      -- 3. Git Clone (Replaces telescope-git-clone)
      vim.api.nvim_create_user_command("GitClone", function()
        local url = vim.fn.input("Clone URL: ")
        if url == "" then return end
        
        -- Try to extract a clean folder name from the repo URL
        local name = url:match("([^/]+)%.git$") or url:match("([^/]+)$")
        
        -- Ask for target directory (default to repo name)
        local target = vim.fn.input("Target directory (default: " .. (name or "") .. "): ")
        if target == "" then target = name end
        if not target or target == "" then return vim.notify("Invalid target", vim.log.levels.ERROR) end
        
        local path = vim.fn.getcwd() .. "/" .. target
        vim.notify("Cloning into " .. path .. "...", vim.log.levels.INFO)
        
        -- Run git clone asynchronously
        vim.system({ "git", "clone", url, target }, { text = true }, function(obj)
          if obj.code == 0 then
            vim.schedule(function()
              vim.notify("Cloned successfully!", vim.log.levels.INFO)
              -- Ask to open the new project
              local confirm = vim.fn.confirm("Open new repo?", "&Yes\n&No", 1)
              if confirm == 1 then
                vim.cmd("cd " .. path)
                vim.cmd("e .") -- Open file explorer
              end
            end)
          else
            vim.schedule(function()
              vim.notify("Clone failed: " .. (obj.stderr or ""), vim.log.levels.ERROR)
            end)
          end
        end)
      end, {})
      map("n", "<leader>gcl", ":GitClone<CR>", { desc = "Git clone (Manual)" })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map("n", "<leader>gb", gs.blame_line,       { desc = "Blame line" })
        map("n", "<leader>gs", gs.stage_hunk,       { desc = "Stage hunk" })
        map("n", "<leader>gu", gs.undo_stage_hunk,  { desc = "Undo stage hunk" })
        map("n", "<leader>gh", gs.preview_hunk,     { desc = "Preview hunk" })
        map("n", "]c", gs.next_hunk,                { desc = "Next hunk" })
        map("n", "[c", gs.prev_hunk,                { desc = "Prev hunk" })
      end,
    },
  },
}
