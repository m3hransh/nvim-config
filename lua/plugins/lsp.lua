return {
  {
    "williamboman/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "folke/neoconf.nvim",
      "smjonas/inc-rename.nvim",
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
      },
      opts = {
        ensure_installed = {
          -- LSP servers (matching your vim.lsp.enable() config)
          "pyright",
          -- "pylsp",
          "ruff",
          "lua-language-server",       -- Lua LSP
          "gopls",                     -- Go LSP
          "typescript-language-server", -- TypeScript LSP
          "rust-analyzer",             -- Rust LSP
          "tailwindcss-language-server", -- Tailwind CSS LSP
          "html-lsp",                  -- HTML LSP
          "css-lsp",                   -- CSS LSP
          "vue-language-server",       -- Vue LSP
          "json-lsp",                  -- JSON LSP (vscode-json-languageserver)

          -- Formatters (for conform.nvim and general use)
          "stylua",
          "goimports",
          -- Note: gofmt comes with Go installation, not managed by Mason
          "prettier",

          -- Linters and diagnostics
          "golangci-lint",
          "eslint_d",
          "luacheck", -- Lua linting
          "pint",   -- Laravel Pint for PHP (formatting & linting)

          -- Additional useful tools
          "delve",    -- Go debugger
          "shfmt",    -- Shell formatter
          "shellcheck", -- Shell linter

          -- Optional but useful additions
          -- "markdownlint", -- Markdown linting
          -- "yamllint",     -- YAML linting
          -- "jsonlint",     -- JSO
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

    end,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>lD", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)" },
      { "<leader>ld", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>lL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location List (Trouble)" },
      { "<leader>lQ", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix List (Trouble)" },
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "VeryLazy",
    opts = {
      symbol_in_winbar = { enable = false },
      lightbulb = { enable = false },
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    event = "BufEnter *.ts,*.tsx",
    opts = {},
  },
  {
    "dense-analysis/ale",
    event = "BufEnter *.hs,*.hls",
    config = function()
      vim.g.ale_ruby_rubocop_auto_correct_all = 1
      vim.g.ale_linters = {
        lua = { "lua_language_server" },
        haskell = { "stack-build" },
      }
    end,
  },
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^4",
    lazy = false,
    keys = {
      { "<leader>lhs", function() require("haskell-tools").hoogle.hoogle_signature() end, desc = "Toggle hoogle" },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_indent_enabled = 0
    end,
    config = function()
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
  },
  {
    "isovector/cornelis",
    ft = "agda",
    build = "stack install",
    dependencies = { "neovimhaskell/nvim-hs.vim", "kana/vim-textobj-user" },
  },
  {
    "grddavies/tidal.nvim",
    opts = {
      boot = {
        tidal = {
          cmd = "tidal",
          enabled = true,
        },
      },
    },
    event = "BufEnter *.tidal",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = { ensure_installed = { "haskell", "supercollider" } },
    },
  },
}
