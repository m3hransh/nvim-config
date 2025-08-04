return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim",                cmd = "Neoconf",   config = true },
      { "smjonas/inc-rename.nvim",           config = true },
      { "williamboman/mason.nvim",           version = "^1.0.0" },
      { "williamboman/mason-lspconfig.nvim", version = "^1.0.0" },
      { "jay-babu/mason-null-ls.nvim",       version = "^1.0.0" },
    },
    opts = {
      servers = {
        dockerls = {},
        lua_ls = {},
        gleam = {},
        ruff = {
          init_options = {
            settings = {
              logFile = "~/ruff.log",
              logLevel = "debug",
              organizeImports = true,
            }

          }
        },
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                -- formatter options
                black = { enabled = false },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                pycodestyle = { enabled = false },
                yapf = { enabled = false },
                pylint = { enabled = true, executable = "pylint" },
                pyflakes = { enabled = false },
                -- type checker
                pylsp_mypy = { enabled = true, report_progress = true, live_mode = false },
              },
            }
          }
        },
        pyright = {
          settings = {
            pyright = {
              --       -- Using Ruff's import organizer
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                diagnosticSeverityOverrides = {
                  reportTypedDictNotRequiredAccess = "none",
                  reportPossiblyUnboundVariable = "warning"
                },
              },
            },
          },
        },
      },
      setup = {
        pyright = function(server, opts)
          local util = require("lspconfig.util")
          local root_dir = util.root_pattern("pyproject.toml", "setup.py", ".git")(vim.loop.cwd())
          if root_dir and root_dir:match("checkmk") then
            return true -- skip pyright if mypy config found
          end
          require("lspconfig")[server].setup(opts)
          return true
        end,

        pylsp = function(server, opts)
          local util = require("lspconfig.util")
          local root_dir = util.root_pattern("pyproject.toml", "setup.py", ".git")(vim.loop.cwd())
          if root_dir and root_dir:match("checkmk") then
            require("lspconfig")[server].setup(opts)
            return true
          end
          return true -- skip pylsp otherwise
        end,
      },
    },
    config = function(plugin, opts)
      require("plugins.lsp.servers").setup(plugin, opts)
    end,
  },
  {
    "williamboman/mason.nvim",
    version = "^1.0.0",
    dependencies = { "jay-babu/mason-nvim-dap.nvim" },
    build = ":MasonUpdate",
    cmd = "Mason",
    keys = { { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
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
    "nvimtools/none-ls.nvim",
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
    'dense-analysis/ale',
    event = "BufEnter  *.hs,*.hls",
    config = function()
      -- Configuration goes here.
      local g = vim.g

      g.ale_ruby_rubocop_auto_correct_all = 1

      g.ale_linters = {
        -- ruby = { 'rubocop', 'ruby' },
        lua = { 'lua_language_server' },
        haskell = { 'stack-build' }
      }
    end
  },
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^4", -- Recommended
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
    branch = "main",
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
      { "<leader>cc", "<cmd>CopilotChatExplain<cr>", desc = "Explain Selected Code" },
      { "<leader>co", "<cmd>CopilotChatToggle<cr>",  desc = "Toggle Copilot Chat" },
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
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "zathura"
    end
  }
}
