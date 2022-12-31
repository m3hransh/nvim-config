local M = {}
local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

-- Conditional mapping based on server_capabilities
local map = vim.api.nvim_buf_set_keymap

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

local function conf(new_opts)
  return vim.tbl_extend("force", opts, new_opts)
end

local function map_cond(cap, b, m, key, cmd, custom_opts)
  if not custom_opts then
    custom_opts = opts
  end
  if cap then
    map(b, m, key, cmd, custom_opts)
  end
end

local function which_cond(dict, cap, key, rhs, desc)
  if cap then
    dict[key] = { rhs, desc }
  end
end

M.setup = function(client, bufnr)
  local rc = client.server_capabilities
  -- vim.pretty_print(rc)

  -- Goto
  local which_keymaps = {
    name = "Goto",
    l = {
      name = "LSP",
      i = { "<cmd>LspInfo<cr>", "LSP Info" },
      I = { "<cmd>LspInstallInfo<cr>", "LSP Installer Info" },
      c = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Actions" },
      l = { "<cmd>Telescope diagnostics<CR>", "Diagnostics List" },
      d = {
        '<cmd>lua vim.diagnostic.open_float({border ="rounded" })<CR>',
        "Show Diagnostc",
      },
      q = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "Quickfix" },
    },
  }
  which_cond(
    which_keymaps,
    rc.declarationProvider,
    "D",
    "<cmd>lua vim.lsp.buf.declaration()<CR>",
    "Goto Declaration"
  )
  which_cond(
    which_keymaps,
    rc.definitionProvider,
    "d",
    "<cmd>lua vim.lsp.buf.definition()<CR>",
    "Goto Definition"
  )
  which_cond(
    which_keymaps,
    rc.implementationProvider,
    "i",
    "<cmd>lua vim.lsp.buf.implementation()<CR>",
    "Goto Implementation"
  )
  which_cond(
    which_keymaps,
    rc.typeDefinitionProvider,
    "t",
    "<cmd>lua vim.lsp.buf.type_definition()<CR>",
    "Goto Type Definition"
  )

  -- Help
  map_cond(
    rc.hoverProvider,
    bufnr,
    "n",
    "K",
    "<cmd>lua vim.lsp.buf.hover()<CR>",
    conf { desc = "Hover" }
  )
  map_cond(
    rc.signatureHelpProvider,
    bufnr,
    "n",
    "<C-k>",
    "<cmd>lua vim.lsp.buf.signature_help()<CR>",
    conf { desc = "Signature Help" }
  )

  -- Code
  which_cond(
    which_keymaps.l,
    rc.codeActionProvider,
    "a",
    "<cmd>lua vim.lsp.buf.code_action()<CR>",
    "Code Actions"
  )
  which_cond(
    which_keymaps.l,
    true,
    "f",
    "<cmd>lua vim.lsp.buf.format { async=false }<CR>",
    "Format"
  )
  which_cond(
    which_keymaps.l,
    rc.referencesProvider,
    "r",
    "<cmd>Telescope lsp_references<CR>",
    "References"
  )
  which_cond(
    which_keymaps.l,
    rc.renameProvider,
    "R",
    "<cmd>lua vim.lsp.buf.rename()<CR>",
    "Rename"
  )
  which_cond(
    which_keymaps.l,
    rc.documentSymbolProvider,
    "s",
    "<cmd>Telescope lsp_document_symbols<cr>",
    "Document Symbols"
  )
  which_cond(
    which_keymaps.l,
    rc.workspaceSymbolProvider,
    "S",
    "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
    "Workspace Symbols"
  )
  which_key.register(
    which_keymaps,
    { buffer = bufnr, prefix = "g", nowait = false, noremap = true }
  )

  -- Diagnostics
  map(
    bufnr,
    "n",
    "[d",
    '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>',
    opts
  )
  map(
    bufnr,
    "n",
    "]d",
    '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>',
    opts
  )
  -- Workspace
  map(
    bufnr,
    "n",
    "<leader>wa",
    "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
    opts
  )
  map(
    bufnr,
    "n",
    "<leader>wr",
    "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
    opts
  )
  map(
    bufnr,
    "n",
    "<leader>wl",
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    opts
  )

  -- you can use <leader>lf for formatting
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.format {async = true}' ]]
end

return M
