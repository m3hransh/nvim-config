-- Helper to disable specific capabilities per client
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
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim"
        },
        opts = { lsp = { auto_attach = true } }
      }
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
                pycodestyle = { enabled = false },
                yapf = { enabled = false },
                pylint = { enabled = false },
                pyflakes = { enabled = false },
                jedi = {
                  enabled = false,
                },
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
      require("mason-nvim-dap").setup(opts)
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = { ensure_installed = nil, automatic_installation = true, automatic_setup = false },
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      {
        "<leader>lD",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>ld",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>lL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>lQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
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
        desc = "Toggle hoogle",
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
  { -- optional blink completion source for require statements and module annotations
    "saghen/blink.cmp",
    opts = {
      ---@module "blink.cmp"
      ---@type blink.cmp.Config
      fuzzy = {
        implementation = "lua",
      },
      sources = {
        -- add lazydev to your completion providers
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_indent_enabled = 0
    end,
    config = function()
      -- runs after plugin loads; also add the hard-off autocmd
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "tex", "plaintex", "latex" },
        callback = function()
          vim.b.did_indent = 1
          vim.bo.indentexpr = ""
          vim.bo.autoindent = false
          vim.bo.smartindent = false
          vim.bo.cindent = false
        end,
      })
    end,
  }
}
