local go_ok, go = pcall(require, "go")
if not go_ok then
  return
end

local path_ok, path = pcall(require, "nvim-lsp-installer.core.path")
if not path_ok then
  return
end
local install_root_dir = path.concat {
  vim.fn.stdpath "data",
  "lsp_servers",
}

go.setup {
  gopls_cmd = { install_root_dir .. "/go/gopls" },
  fillstruct = "gopls",
  goimport = "gopls", -- if set to 'gopls' will use gopls format, also goimport
  gofmt = "gofumpt", -- if set to gopls will use gopls format
  max_line_len = 120,
  tag_transform = false,
  test_dir = "",
  comment_placeholder = "   ",
  icons = { breakpoint = "🧘", currentpos = "🏃" }, -- set to false to disable
  -- this option
  lsp_inlay_hints = {
    enable = false,
  },
  verbose = false,
  log_path = vim.fn.expand "$HOME" .. "/tmp/gonvim.log",
  lsp_cfg = false, -- false: do nothing
  -- true: apply non-default gopls setup defined in go/lsp.lua
  -- if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
  lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt
  lsp_on_attach = nil, -- nil: do nothing
  -- if lsp_on_attach is a function: use this function as on_attach function for gopls,
  -- when lsp_cfg is true
  lsp_keymaps = false, -- true: apply default lsp keymaps
  lsp_codelens = true,
  lsp_diag_hdlr = true, -- hook lsp diag handler
  gopls_remote_auto = true,
  gocoverage_sign = "█",
  gocoverage_sign_priority = 5,
  dap_debug = true,
  dap_debug_gui = true,
  dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua
  -- false: do not use keymap in go/dap.lua.  you must define your own.
  -- windows: use visual studio style of keymap
  dap_vt = true, -- false, true and 'all frames'
  textobjects = true,
}
