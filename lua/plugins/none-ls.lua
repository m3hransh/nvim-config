return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    -- Custom source to run ruff with --fix for organize imports
    local ruff_organize = {
      name="ruff_organize",
      method = null_ls.methods.FORMATTING,
      filetypes = { "python" },
      generator = null_ls.formatter({
        command = "ruff",
        args = { "check", "--fix", "--select", "I", "--stdin-filename", "$FILENAME", "-" },
        to_stdin = true,
      }),
    }
    null_ls.setup({
      sources = {
        ruff_organize,
      },
    })
  end,
}
