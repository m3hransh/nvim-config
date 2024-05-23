return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	keys = {
		{
			"<leader>ff",
			"<cmd>lua require('telescope.builtin').find_files("
				.. "vim.tbl_deep_extend('force', require('telescope.themes').get_dropdown{previewer = false},"
				.. "{find_command = {'rg', '--files', '--hidden', '-g', '!.git' }}))<CR>",
			desc = "Find Files",
		},
		{
			"<leader>fr",
			"<cmd>Telescope oldfiles<cr>",
			desc = "Recent",
		},
		{
			"<leader>fb",
			"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
			desc = "Buffers",
		},
		{
			"<leader>fg",
			"<cmd>Telescope git_files<cr>",
			desc = "Git Files",
		},
		{
			"<leader>P",
			"<cmd>lua require('telescope').extensions.projects.projects()<cr>",
			desc = "Projects",
		},
		{
			"<leader>f/",
			"<cmd>lua require('telescope.builtin').live_grep("
				.. "vim.tbl_deep_extend('force', require('telescope.themes').get_ivy(),"
				.. "{find_command = {'rg', '--files', '--hidden', '-g', '!.git' }}))<CR>",
			desc = "Grep",
		},
	},
	config = true,
}
