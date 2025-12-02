return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-python",
      "mrcjkb/neotest-haskell",
      "nvim-neotest/neotest-go",
      {
        "stevearc/overseer.nvim",

        tag = "v1.6.0"
      },
    },
    keys = {
      { "<leader>td", "<cmd>w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", desc = "Debug File" },
      { "<leader>tL", "<cmd>w|lua require('neotest').run.run_last({strategy = 'dap'})<cr>",                desc = "Debug Last" },
      { "<leader>ta", "<cmd>w|lua require('neotest').run.attach()<cr>",                                    desc = "Attach" },
      { "<leader>tf", "<cmd>w|lua require('neotest').run.run(vim.fn.expand('%'))<cr>",                     desc = "File" },
      { "<leader>tF", "<cmd>w|lua require('neotest').run.run(vim.loop.cwd())<cr>",                         desc = "All Files" },
      { "<leader>tl", "<cmd>w|lua require('neotest').run.run_last()<cr>",                                  desc = "Last" },
      { "<leader>tn", "<cmd>w|lua require('neotest').run.run()<cr>",                                       desc = "Nearest" },
      { "<leader>tN", "<cmd>w|lua require('neotest').run.run({strategy = 'dap'})<cr>",                     desc = "Debug Nearest" },
      { "<leader>to", "<cmd>w|lua require('neotest').output.open({ enter = true })<cr>",                   desc = "Output" },
      { "<leader>ts", "<cmd>w|lua require('neotest').run.stop()<cr>",                                      desc = "Stop" },
      { "<leader>tw", "<cmd>w|lua require('neotest').watch.watch()<cr>",                                   desc = "Watch" },
      { "<leader>tS", "<cmd>w|lua require('neotest').summary.toggle()<cr>",                                desc = "Summary" },
    },
    opts = function()
      return {
        adapters = {
          require "neotest-plenary",
          require "neotest-haskell",
          require "neotest-go",
          require("neotest-python")({
            -- Extra arguments for nvim-dap configuration
            -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
            dap = { justMyCode = false },
            -- Command line arguments for runner
            -- Can also be a function to return dynamic values
            args = { "--log-level", "DEBUG" },
            -- Runner to use. Will use pytest if available by default.
            -- Can be a function to return dynamic value.
            runner = "pytest",
            -- Custom python path for the runner.
            -- Can be a string or a list of strings.
            -- Can also be a function to return dynamic value.
            -- If not provided, the path will be inferred by checking for
            -- virtual envs in the local directory and for Pipenev/Poetry configs
            python = ".venv/bin/python",
            -- Returns if a given file path is a test file.
            -- NB: This function is called a lot so don't perform any heavy tasks within it.
            -- is_test_file = function(file_path)
            --   return file_path:match("tests/unit/")
            -- end,
            -- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
            -- instances for files containing a parametrize mark (default: false)
            pytest_discover_instances = false,
          }) },
        status = { virtual_text = true },
        output = { open_on_run = true },
        -- overseer.nvim
        consumers = {
          overseer = require "neotest.consumers.overseer",
        },
        overseer = {
          enabled = true,
          force_default = true,
        },
      }
    end,
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup(opts)
    end,
  },
  {
    "stevearc/overseer.nvim",
    tag = "v1.6.0",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>oR", "<cmd>OverseerRunCmd<cr>",       desc = "Run Command" },
      { "<leader>oa", "<cmd>OverseerTaskAction<cr>",   desc = "Task Action" },
      { "<leader>ob", "<cmd>OverseerBuild<cr>",        desc = "Build" },
      { "<leader>oc", "<cmd>OverseerClose<cr>",        desc = "Close" },
      { "<leader>od", "<cmd>OverseerDeleteBundle<cr>", desc = "Delete Bundle" },
      { "<leader>ol", "<cmd>OverseerLoadBundle<cr>",   desc = "Load Bundle" },
      { "<leader>oo", "<cmd>OverseerOpen<cr>",         desc = "Open" },
      { "<leader>oq", "<cmd>OverseerQuickAction<cr>",  desc = "Quick Action" },
      { "<leader>or", "<cmd>OverseerRun<cr>",          desc = "Run" },
      { "<leader>os", "<cmd>OverseerSaveBundle<cr>",   desc = "Save Bundle" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>",       desc = "Toggle" },
    },
    config = function(opts)
      require("overseer").setup({
        templates = { "builtin", "checkmk.f12" },
      })
    end,
  }
}
