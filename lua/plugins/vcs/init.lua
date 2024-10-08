return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = true,
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    opts = {
      integrations = { diffview = true },
      disable_commit_confirmation = true,
    },
    keys = {
      { "<leader>gn", "<cmd>Neogit kind=tab<cr>", desc = "Status" },
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "GBrowse", "Gdiffsplit", "Gvdiffsplit" },
    dependencies = {
      "tpope/vim-rhubarb",
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      icons = require('config.icons')
      require('gitsigns').setup {

        -- update_debounce = 100,
        on_attach = function(bufnr)
          local gs = require('gitsigns')
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          -- Actions
          map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
          map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })
          map({ "n", "v" }, "<leader>gf", ":Telescope git_status<CR>", { desc = "File changed" })
          map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage Buffer" })
          map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
          map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset Buffer" })
          map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
          map("n", "<leader>gb", function()
            gs.blame_line({ full = true })
          end, { desc = "Blame Line" })
          map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "Toggle Line Blame" })
          map("n", "<leader>ghd", gs.diffthis, { desc = "Diff This" })
          map("n", "<leader>ghD", function()
            gs.diffthis("~")
          end, { desc = "Diff This ~" })
          map("n", "<leader>gtd", gs.toggle_deleted, { desc = "Toggle Delete" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
        end,
      }
    end,
  },
  {
    "mattn/vim-gist",
    dependencies = { "mattn/webapi-vim" },
    cmd = { "Gist" },
    config = function()
      vim.g.gist_open_browser_after_post = 1
    end,
  },
  {
    "rawnly/gist.nvim",
    cmd = { "CreateGist", "CreateGistFromFile" },
  },
  {
    "aaronhallaert/advanced-git-search.nvim",
    config = function()
      require("telescope").load_extension("advanced_git_search")
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-fugitive",
    },
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    opts = {},
    config = function()
      require("telescope").load_extension("git_worktree")
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    --stylua: ignore
    keys = {
      { "<leader>gwm", function() require("telescope").extensions.git_worktree.git_worktrees() end,       desc = "Manage" },
      { "<leader>gwc", function() require("telescope").extensions.git_worktree.create_git_worktree() end, desc = "Create" },
    },
  },
  -- {
  -- 	"akinsho/git-conflict.nvim",
  --    --stylua: ignore
  --    keys = {
  --      {"<leader>gC", function() require("plugins.hydra.git-action").open_git_conflict_hydra() end, desc = "Conflict"},
  --      {"<leader>gS", function() require("plugins.hydra.git-action").open_git_signs_hydra() end, desc = "Signs"},
  --    },
  -- 	cmd = {
  -- 		"GitConflictChooseBoth",
  -- 		"GitConflictNextConflict",
  -- 		"GitConflictChooseOurs",
  -- 		"GitConflictPrevConflict",
  -- 		"GitConflictChooseTheirs",
  -- 		"GitConflictListQf",
  -- 		"GitConflictChooseNone",
  -- 		"GitConflictRefresh",
  -- 	},
  -- 	opts = {
  -- 		default_mappings = true,
  -- 		default_commands = true,
  -- 		disable_diagnostics = true,
}
