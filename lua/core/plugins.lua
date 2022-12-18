local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data"
  .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim"
  use "nvim-lua/popup.nvim"
  use "nvim-lua/plenary.nvim"
  use "windwp/nvim-autopairs"
  use "windwp/nvim-ts-autotag"
  use "numToStr/Comment.nvim"
  use "kyazdani42/nvim-web-devicons"
  use "kyazdani42/nvim-tree.lua"
  use "akinsho/bufferline.nvim"
  use "moll/vim-bbye"
  use "nvim-lualine/lualine.nvim"
  use "folke/neodev.nvim"
  use "akinsho/toggleterm.nvim"
  use "ahmedkhalf/project.nvim"
  use "lewis6991/impatient.nvim"
  use "lukas-reineke/indent-blankline.nvim"
  use "goolord/alpha-nvim"
  use "antoinemadec/FixCursorHold.nvim"
  use "folke/which-key.nvim"
  -- use "rcarriga/nvim-notify"
  use "b0o/incline.nvim"

  -- Colorschemes
  -- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
  -- use "lunarvim/darkplus.nvim"
  use "folke/tokyonight.nvim"

  use "norcalli/nvim-colorizer.lua"
  use "kylechui/nvim-surround"

  -- cmp plugins
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "ray-x/cmp-treesitter",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "rafamadriz/friendly-snippets",
    },
  }

  -- LSP outline
  use {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
  }

  use "jbyuki/instant.nvim"
  -- snippets
  use "L3MON4D3/LuaSnip"
  use "rafamadriz/friendly-snippets"

  -- LSP
  use {
    "neovim/nvim-lspconfig",
    -- opt = true,
    -- event = "BufReadPre",
    wants = {
      "cmp-nvim-lsp",
      "nvim-lsp-installer",
      "lua-dev.nvim",
    },
    requires = {
      "williamboman/nvim-lsp-installer",
      "folke/lua-dev.nvim",
    },
  }
  use "jose-elias-alvarez/null-ls.nvim"
  use "ray-x/go.nvim"
  use "ray-x/guihua.lua" -- floating window support

  -- Java
  use { "mfussenegger/nvim-jdtls", ft = { "java" } }

  -- Refactoring
  use {
    "ThePrimeagen/refactoring.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  }
  -- Debug
  use "mfussenegger/nvim-dap"
  use "theHamsta/nvim-dap-virtual-text"
  use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
  use "nvim-telescope/telescope-dap.nvim"

  -- Telescope
  use "nvim-telescope/telescope.nvim"

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  use "nvim-treesitter/nvim-treesitter-textobjects"
  use "JoosepAlviste/nvim-ts-context-commentstring"

  -- Git
  use "lewis6991/gitsigns.nvim"

  -- Markdown
  use {
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  }
  -- Discord presence
  use "andweeb/presence.nvim"

  -- Copilot
  -- use "github/copilot.vim"
  use {
    "zbirenbaum/copilot.lua",
    -- event = { "VimEnter" },
    -- config = function()
    --   vim.defer_fn(function()
    --     require("copilot").setup {
    --       ft_disable = { "markdown", "dap-repl" },
    --     }
    --   end, 100)
    -- end,
  }
  use {
    "zbirenbaum/copilot-cmp",
    module = "copilot_cmp",
  }
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
