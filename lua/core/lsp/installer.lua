local M = {}

function M.setup(servers, options)
  local mason_ok, mason                               = pcall(require, "mason")
  local mason_conf_ok, mason_conf                     = pcall(require, "mason-lspconfig")
  local mason_tool_installer_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
  local lspconfig_ok, lspconfig                       = pcall(require, "lspconfig")
  local neodev_ok, neodev                             = pcall(require, 'neodev')
  if not mason_ok or not mason_conf_ok or not lspconfig_ok or not mason_tool_installer_ok then
    return
  end

  -- NOTE:setup neodev before lspconfig in mason_conf
  if neodev_ok then
    neodev.setup {}
  end
  mason.setup {}
  mason_tool_installer.setup {
    ensure_installed = { "codelldb", "stylua", "shfmt", "shellcheck", "black", "isort", "prettierd" },
    auto_update = false,
    run_on_start = true,
  }
  mason_conf.setup {
    ensure_installed = vim.tbl_keys(servers),
    automatic_installation = false,
  }

  -- Package installation folder
  local install_root_dir = vim.fn.stdpath "data" .. "/mason"

  mason_conf.setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)

      local opts = vim.tbl_deep_extend("force", options, servers[server_name] or {})

      require("lspconfig")[server_name].setup(opts)
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    -- For example, a handler override for the `rust_analyzer`:
    ["jdtls"] = function()
      -- print "jdtls is handled by nvim-jdtls" TODO: add java support
      --[[ require("jdtls").setup_dap { hotcodereplace = "auto" } ]]
      --[[ require("jdtls.dap").setup_dap_main_class_configs() ]]
      --[[ vim.lsp.codelens.refresh() ]]
    end,
    ["rust_analyzer"] = function()

      local opts = vim.tbl_deep_extend("force", options, servers["rust_analyzer"] or {})

      local rust_tools_ok, rust_tools = pcall(require, 'rust-tools')
      if rust_tools_ok then
        local extension_path = install_root_dir .. "/packages/codelldb/extension/"
        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
        rust_tools.setup {
          tools = {
            autoSetHints = false,
            executor = require("rust-tools/executors").toggleterm,
            hover_actions = { border = "solid" },
            on_initialized = function()
              vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
                pattern = { "*.rs" },
                callback = function()
                  vim.lsp.codelens.refresh()
                end,
              })
            end,
          },
          server = opts,
          dap = {
            adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
          },
        }
      end

    end,
    ["tsserver"] = function()
      local opts = vim.tbl_deep_extend("force", options, servers["tsserver"] or {})
      --[[ require("typescript").setup { ]]
      --[[   disable_commands = false, ]]
      --[[   debug = false, ]]
      --[[   server = opts, ]]
      --[[ } ]]
    end,
  }
end

return M
