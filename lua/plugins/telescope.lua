return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    {
      "<leader>f",
      "<cmd>lua require('telescope.builtin').find_files(" ..
      "vim.tbl_deep_extend('force', require('telescope.themes').get_dropdown()," ..
      "{find_command = {'rg', '--files', '--hidden', '-g', '!.git', '-g', '!~/bazel-*' }, filename_first = true, path_display = { 'truncate' } } ))<CR>",
      desc = "Find Files",
    },
    {
      "<leader>b",
      "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown())<cr>",
      desc = "Buffers",
    },
    {
      "<leader>tg",
      "<cmd>Telescope git_files<cr>",
      desc = "Git Files",
    },
    {
      "<leader>P",
      "<cmd>lua require('telescope').extensions.projects.projects()<cr>",
      desc = "Projects",
    },
    {
      "<leader>F",
      "<cmd>lua require('telescope.builtin').live_grep("
      .. "vim.tbl_deep_extend('force', require('telescope.themes').get_ivy(),"
      .. "{find_command = {'rg', '--files', '--hidden', '-g', '!.git' }}))<CR>",
      desc = "Grep",
    },
    -- in visual mode
    {
      "<leader>F",
      "<cmd>lua require('telescope.builtin').grep_string("
      .. "vim.tbl_deep_extend('force', require('telescope.themes').get_ivy(),"
      .. "{find_command = {'rg', '--files', '--hidden', '-g', '!.git' }}))<CR>",
      desc = "Grep",
      mode = "v",
    },
    {
      "<leader><tab>",
      "<cmd>lua require('telescope.builtin').commands()<cr>",
      desc = "Help",
      noremap = false,
    },
  },
  config = true,
}
