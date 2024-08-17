return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require "which-key"
    wk.setup {
      show_help = false,
      plugins = { spelling = true },
      replace = {
        key = {
          function(key)
            return require("which-key.view").format(key)
          end,
          { "<Space>", "SPC" },
        },
        desc = {
          { "<Plug>%(?(.*)%)?", "%1" },
          { "^%+",              "" },
          { "<[cC]md>",         "" },
          { "<[cC][rR]>",       "" },
          { "<[sS]ilent>",      "" },
          { "^lua%s+",          "" },
          { "^call%s+",         "" },
          { "^:%s*",            "" },
        },
      },
      triggers = {
        { "<auto>", mode = "nxsot" },
      }
    }
    wk.add({
      { "<leader>w", proxy = "<c-w>", group = "Windows" },
      { "<leader>g", "Git" },
      { "<leader>c", "Code" },
    })
  end,
}
