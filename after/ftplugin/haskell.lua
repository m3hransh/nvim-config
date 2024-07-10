local ht = require("haskell-tools")

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true, buffer = bufnr }

local function conf(new_opts)
  return vim.tbl_extend("force", opts, new_opts)
end
local bufnr = vim.api.nvim_get_current_buf()
-- haskell-language-server relies heavily on codeLenses,
-- so auto-refresh (see advanced configuration) is enabled by default
keymap("n", "<space>lc", vim.lsp.codelens.run, conf({ desc = "Auto Refresh" }))
-- Hoogle search for the type signature of the definition under the cursor
vim.keymap.set("n", "<space>lh", ht.hoogle.hoogle_signature, conf({ desc = "type signature" }))
-- Evaluate all code snippets
vim.keymap.set("n", "<space>le", ht.lsp.buf_eval_all, conf({ desc = "Evaluate all" }))
-- Toggle a GHCi repl for the current package
vim.keymap.set("n", "<leader>lr", ht.repl.toggle, conf({ desc = "repl for the current package" }))
-- Toggle a GHCi repl for the current buffer
vim.keymap.set("n", "<leader>lf", function()
  ht.repl.toggle(vim.api.nvim_buf_get_name(0))
end, conf({ desc = "GHCi repl for the current buffer" }))

vim.keymap.set("n", "<leader>rq", ht.repl.quit, conf({ desc = "Quit repl" }))

vim.g.haskell_tools = {
  tools = {
    -- ...
    codelens = {
      autoRefresh = false,
    },
  },
}
