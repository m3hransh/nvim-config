return {
	"nvim-lua/plenary.nvim",
	"MunifTanjim/nui.nvim",
	{
		"nvim-tree/nvim-web-devicons",
		config = { default = true },
	},
	{ "nacro90/numb.nvim", event = "BufReadPre", config = true },
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		config = true,
	},
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		enabled = true,
		config = { default = true }, -- same as config = true
	},
	{
		"norcalli/nvim-colorizer.lua",
		event = { "BufReadPost" },
		config = function()
			require("colorizer").setup({
				"*", -- Highlight all files, but customize some others.
				css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
				html = { names = false }, -- Disable parsing "names" like Blue or Gray
			})
		end,
	},
	{
		"numToStr/Comment.nvim",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		keys = { { "gc", mode = { "n", "v" } }, { "gcc", mode = { "n", "v" } }, { "gbc", mode = { "n", "v" } } },
		config = function(_, _)
			local opts = {
				ignore = "^$",
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			}
			require("Comment").setup(opts)
		end,
	},
	-- {
	--   "iamcco/markdown-preview.nvim",
	--   ft = "markdown",
	--   -- build = "cd app && npm install",
	--   --build = ":call mkdp#util#install()",
	-- },
	--  {
	--    "monaqa/dial.nvim",
	--    event = "BufReadPre",
	--    config = function()
	--      vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
	--      vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
	--      vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
	--      vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
	--      vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
	--      vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })
	--    end,
	--  },
}
