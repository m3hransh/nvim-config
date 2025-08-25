return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufEnter" },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    { "]t",         "<cmd>w|lua require('todo-comments').jump_next()<cr>", desc = "Next todo comment" },
    { "[t",         "<cmd>w|lua require('todo-comments').jump_prev()<cr>", desc = "Previous todo comment" },
    { "<leader>tt", "<cmd>TodoTelescope<cr>",                              desc = "Todo list" },
  },
}
