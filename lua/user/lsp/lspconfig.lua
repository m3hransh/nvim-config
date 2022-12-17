local M = {}

local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
  return
end

local handlers = require "user.lsp.handlers"

local default_opts = {
  capabilities = handlers.capabilities,
  on_attach = handlers.on_attach,
}

local function config(_config)
  return vim.tbl_deep_extend("force", default_opts, _config or {})
end

M.setup = function(servers)
  -- all the general lspconfig config is in handlers
  handlers.setup()
  for _, server in pairs(servers) do
    if server == "sumneko_lua" then
      local opts = config(require "user.lsp.settings.sumneko_lua")
      -- Add support for Nvim API
      lspconfig[server].setup(opts)
    elseif server == "jsonls" then
      lspconfig[server].setup(config(require "user.lsp.settings.jsonls"))
    elseif server == "gopls" then
      local go_opts = require("go.lsp").config()
      -- Use default
      lspconfig[server].setup(
        vim.tbl_deep_extend("force", go_opts, default_opts)
      )
    else
      lspconfig[server].setup(default_opts)
    end
  end
end

return M
