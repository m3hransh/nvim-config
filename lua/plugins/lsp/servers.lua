local M = {}

local lsp_utils = require("plugins.lsp.utils")
local icons = require("config.icons")

local function lsp_init()
  -- Diagnostic signs using vim.diagnostic.config instead of deprecated sign_define
  local signs = {
    [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
    [vim.diagnostic.severity.WARN]  = icons.diagnostics.Warning,
    [vim.diagnostic.severity.HINT]  = icons.diagnostics.Hint,
    [vim.diagnostic.severity.INFO]  = icons.diagnostics.Info,
  }

  -- LSP handlers configuration
  local config = {
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
    },

    diagnostic = {
      virtual_text = {
        severity = {
          min = vim.diagnostic.severity.ERROR,
        },
      },
      signs = {
        text = signs,
      },
      underline = false,
      update_in_insert = false,
      severity_sort = true,
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
      -- virtual_lines = true,
    },
  }

  -- Diagnostic configuration (replaces sign_define)
  vim.diagnostic.config(config.diagnostic)

  -- Optionally enable floating window styles for hover and signature help
  -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, config.float)
  -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, config.float)
end

function M.setup(_, opts)
	lsp_utils.on_attach(function(client, bufnr)
		require("plugins.lsp.format").on_attach(client, bufnr)
		require("plugins.lsp.keymaps").on_attach(client, bufnr)
	end)

	lsp_init() -- diagnostics, handlers

	local servers = opts.servers
	local capabilities = lsp_utils.capabilities()

	local function setup(server)
		local server_opts = vim.tbl_deep_extend("force", {
			capabilities = capabilities,
		}, servers[server] or {})

		if opts.setup[server] then
			if opts.setup[server](server, server_opts) then
				return
			end
		elseif opts.setup["*"] then
			if opts.setup["*"](server, server_opts) then
				return
			end
		end
		if server == "angularls" then
			server_opts.root_dir = require("lspconfig.util").root_pattern("package.json", "project.json")
		end
		require("lspconfig")[server].setup(server_opts)
	end

	-- Add bun for Node.js-based servers
	-- local llocal util = require('lspconfig.util')

	-- local add_bun_prefix = require("plugins.lsp.bun").add_bun_prefix
	-- lspconfig_util.on_setup = lspconfig_util.add_hook_before(lspconfig_util.on_setup, add_bun_prefix)

	-- get all the servers that are available thourgh mason-lspconfig
	local have_mason, mlsp = pcall(require, "mason-lspconfig")
	local all_mslp_servers = {}
	if have_mason then
		all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
	end

	local ensure_installed = {} ---@type string[]
	for server, server_opts in pairs(servers) do
		if server_opts then
			server_opts = server_opts == true and {} or server_opts
			-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
			if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
				setup(server)
			else
				ensure_installed[#ensure_installed + 1] = server
			end
		end
	end

	if have_mason then
		mlsp.setup({ ensure_installed = ensure_installed })
		mlsp.setup_handlers({ setup })
	end
end

return M
