return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim",      cmd = "Neoconf", config = true },
      { "smjonas/inc-rename.nvim", config = true },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    opts = {
      servers = {
        dockerls = {},
        lua_ls = {},
        gleam = {},
      },
      setup = {},
      format = {
        timeout_ms = 3000,
      },
    },
    config = function(plugin, opts)
      require("plugins.lsp.servers").setup(plugin, opts)
    end,
  },
  {
    "williamboman/mason.nvim",
    dependencies = { "jay-babu/mason-nvim-dap.nvim" },
    build = ":MasonUpdate",
    cmd = "Mason",
    keys = { { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "shfmt",
      },
      PATH = "append",
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
      local opts = { ensure_installed = { "python", "delve", "elixir" } }
      require("mason-nvim-dap").setup(opts)
    end,
  },
  --
  -- {
  --   "jay-babu/mason-nvim-dap.nvim",
  --   event = "BufReadPre",
  --   opts = { ensure_installed = { "python", "delve", "elixir" } },
  --   dependencies = { "mason.nvim" },
  --   config = function(_, opts)
  --     require("mason-nvim-dap").setup(opts)
  --   end,
  -- },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.formatting.shfmt,
        },
      }
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = { ensure_installed = nil, automatic_installation = true, automatic_setup = false },
  },
  {
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    enabled = false, -- use lspsaga
    config = true,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>ld", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics" },
      { "<leader>lD", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "VeryLazy",
    opts = {
      symbol_in_winbar = {
        enable = false,
      },
      lightbulb = {
        enable = false,
      },
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    enabled = function()
      return vim.fn.has("nvim-0.10.0") == 1
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    event = "BufEnter  *.ts,*.tsx",
    opts = {},
  },
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^3", -- Recommended
    lazy = false,   -- This plugin is already lazy
    keys = {
      {
        "<leader>lhs",
        function()
          require("haskell-tools").hoogle.hoogle_signature()
        end,
        desc = "Toggle Haskell Tools",
      },
    },
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false,   -- This plugin is already lazy
  },
  -- {
  -- 	"elixir-tools/elixir-tools.nvim",
  -- 	version = "*",
  -- 	event = "BufReadPre",
  -- 	keys = {
  -- 		{ "<leader>fp", "<cmd>ElixirFromPipe<cr>", desc = "From Pipe" },
  -- 		{ "<leader>tp", "<cmd>ElixirToPipe<cr>", desc = "To Pipe" },
  -- 		{ "<leader>em", "<cmd>ElixirExpandMacro<cr>", desc = "Expand Macro" },
  -- 	},
  -- 	config = function()
  -- 		local elixir = require("elixir")
  -- 		local elixirls = require("elixir.elixirls")

  -- 		elixir.setup({
  -- 			nextls = { enable = true },
  -- 			credo = {},
  -- 			elixirls = {
  -- 				enable = true,
  -- 				settings = elixirls.settings({
  -- 					dialyzerEnabled = true,
  -- 					enableTestLenses = true,
  -- 				}),
  -- 			},
  -- 		})
  -- 	end,
  -- 	dependencies = {
  -- 		"nvim-lua/plenary.nvim",
  -- 	},
  -- },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
    keys = {
      { "<leader>cc", "<cmd>CopilotChatExplain<cr>", desc = "Toggle Copilot Chat" },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
}
