local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "user.lsp.neodev"
local servers = require("user.lsp.lsp-installer").servers
require "user.lsp.go"
require("user.lsp.lspconfig").setup(servers)
require "user.lsp.null-ls"
-- For debuging other than GO use this
require "user.lsp.dap"
