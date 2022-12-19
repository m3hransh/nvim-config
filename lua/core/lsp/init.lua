local mason_ok, mason           = pcall(require, "mason")
local mason_conf_ok, mason_conf = pcall(require, "mason-lspconfig")
local lspconfig_ok, _           = pcall(require, "lspconfig")
local handler                   = require("core.lsp.handler")

if not mason_ok or not mason_conf_ok or not lspconfig_ok then
  return
end


mason.setup {}
mason_conf.setup {
  ensure_installed = { "sumneko_lua", "rust_analyzer" }
}
handler.setup()



require("mason-lspconfig").setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    local opts = {
      on_attach = handler.on_attach,
      capabilities = handler.capabilities,
    }

    local require_ok, server = pcall(require, "core.lsp.settings." .. server_name)
    if require_ok then
      opts = vim.tbl_deep_extend("force", server, opts)
    end

    require("lspconfig")[server_name].setup(opts)
  end,
  -- Next, you can provide a dedicated handler for specific servers.
  -- For example, a handler override for the `rust_analyzer`:
  --[[ ["rust_analyzer"] = function() ]]
  --[[   require("rust-tools").setup {} ]]
  --[[ end ]]
}
