local M = {}


M.servers = {
  "cssls",
  "gopls",
  "svelte",
  "cssmodules_ls",
  "emmet_ls",
  "html",
  "jsonls",
  "solc",
  "sumneko_lua",
  "tflint",
  "tsserver",
  "pyright",
  "yamlls",
  "bashls",
  "clangd",
  "rust_analyzer",
  --[[ "jdtls", ]]
  -- "taplo",
}

local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return M
end

local settings = {
  ensure_installed = M.servers,
  ui = {
    icons = {},
    keymaps = {
      toggle_server_expand = "<CR>",
      install_server = "i",
      update_server = "u",
      check_server_version = "c",
      update_all_servers = "U",
      check_outdated_servers = "C",
      uninstall_server = "X",
    },
  },

  log_level = vim.log.levels.INFO,
}

lsp_installer.setup(settings)

return M
