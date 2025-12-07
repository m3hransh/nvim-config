return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      defaults = {
        ["<leader>d"] = { name = "+DAP" },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui" },
      { "theHamsta/nvim-dap-virtual-text" },
      { "nvim-neotest/nvim-nio" },
      { "mfussenegger/nvim-dap-python" }, -- for Python
      { "leoluz/nvim-dap-go" },           -- for Go
    },
    -- stylua: ignore
    keys = {
      { "<leader>dR", function() require("dap").run_to_cursor() end, desc = "Run to Cursor", },
      {
        "<leader>dE",
        function() require("dapui").eval(vim.fn.input "[Expression] > ") end,
        desc =
        "Evaluate Input",
      },
      {
        "<leader>dC",
        function() require("dap").set_breakpoint(vim.fn.input "[Condition] > ") end,
        desc =
        "Conditional Breakpoint",
      },
      {
        "<leader>dU",
        function() require("dapui").toggle() end,
        desc = "Toggle UI",
      },
      {
        "<leader>db",
        function() require("dap").step_back() end,
        desc = "Step Back",
      },
      {
        "<leader>dc",
        function() require("dap").continue() end,
        desc = "Continue",
      },
      {
        "<leader>dd",
        function() require("dap").disconnect() end,
        desc = "Disconnect",
      },
      {
        "<leader>de",
        function() require("dapui").eval() end,
        mode = { "n", "v" },
        desc =
        "Evaluate",
      },
      {
        "<leader>dg",
        function() require("dap").session() end,
        desc = "Get Session",
      },
      {
        "<leader>dh",
        function() require("dap.ui.widgets").hover() end,
        desc =
        "Hover Variables",
      },
      {
        "<leader>dS",
        function() require("dap.ui.widgets").scopes() end,
        desc = "Scopes",
      },
      {
        "<leader>di",
        function() require("dap").step_into() end,
        desc = "Step Into",
      },
      { "<leader>do", function() require("dap").step_over() end,     desc = "Step Over", },
      { "<leader>dp", function() require("dap").pause.toggle() end,  desc = "Pause", },
      { "<leader>dq", function() require("dap").close() end,         desc = "Quit", },
      { "<leader>dr", function() require("dap").repl.toggle() end,   desc = "Toggle REPL", },
      { "<leader>ds", function() require("dap").continue() end,      desc = "Start", },
      {
        "<leader>dt",
        function() require("dap").toggle_breakpoint() end,
        desc =
        "Toggle Breakpoint",
      },
      { "<leader>dx", function() require("dap").terminate() end, desc = "Terminate", },
      { "<leader>du", function() require("dap").step_out() end,  desc = "Step Out", },
    },
    opts = {},
    config = function(plugin, opts)
      require("nvim-dap-virtual-text").setup({
        commented = true,
      })

      local dap, dapui = require("dap"), require("dapui")
      dapui.setup({})

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Python adapter (debugpy must be installed in your venv)
      require("dap-python").setup()

      -- Optional: settings for test debugging
      require("dap-python").test_runner = "pytest"
      -- TODO: DAP for Elixir didn't work

      dap.set_log_level("TRACE")
      require('dap-go').setup {
        -- Additional dap configurations can be added.
        -- dap_configurations accepts a list of tables where each entry
        -- represents a dap configuration. For more details do:
        -- :help dap-configuration
        dap_configurations = {
          {
            -- Must be "go" or it will be ignored by the plugin
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
        },
        -- delve configurations
        delve = {
          -- the path to the executable dlv which will be used for debugging.
          -- by default, this is the "dlv" executable on your PATH.
          path = "dlv",
          -- time to wait for delve to initialize the debug session.
          -- default to 20 seconds
          initialize_timeout_sec = 20,
          -- a string that defines the port to start delve debugger.
          -- default to string "${port}" which instructs nvim-dap
          -- to start the process in a random available port.
          -- if you set a port in your debug configuration, its value will be
          -- assigned dynamically.
          port = "${port}",
          -- additional args to pass to dlv
          args = {},
          -- the build flags that are passed to delve.
          -- defaults to empty string, but can be used to provide flags
          -- such as "-tags=unit" to make sure the test suite is
          -- compiled during debugging, for example.
          -- passing build flags using args is ineffective, as those are
          -- ignored by delve in dap mode.
          -- avaliable ui interactive function to prompt for arguments get_arguments
          build_flags = {},
          -- whether the dlv process to be created detached or not. there is
          -- an issue on delve versions < 1.24.0 for Windows where this needs to be
          -- set to false, otherwise the dlv server creation will fail.
          -- avaliable ui interactive function to prompt for build flags: get_build_flags
          detached = vim.fn.has("win32") == 0,
          -- the current working directory to run dlv from, if other than
          -- the current working directory.
          cwd = nil,
        },
        -- options related to running closest test
        tests = {
          -- enables verbosity when running the test.
          verbose = false,
        },
      }
      -- set up debugger
      -- for k, _ in pairs(opts.setup) do
      -- 	opts.setup[k](plugin, opts)
      -- end
      -- local elixir_ls_debugger = vim.fn.exepath "elixir-ls-debugger"
      -- if elixir_ls_debugger then
      --   dap.adapters.mix_task = {
      --     type = 'executable',
      --     command = elixir_ls_debugger, -- https://github.com/williamboman/mason.nvim/blob/d97579ccd5689f9c6c365e841ea99c27954112ec/lua/mason-registry/elixir-ls/init.lua#L26
      --     args = {},
      --   }
      -- dap.configurations.elixir = {
      --   {
      --     type = "mix_task",
      --     request = "launch",
      --     name = "Mix Run",
      --     task = "run",
      --     cwd = "${workspaceFolder}",
      --     args = {},
      --     mix_env = "dev",
      --   },
      --   {
      --     type = "mix_task",
      --     request = "launch",
      --     name = "Mix Test",
      --     task = "test",
      --     cwd = "${workspaceFolder}",
      --     args = {},
      --     mix_env = "test",
      --   },
      -- }
      -- end
    end,
  },
}
