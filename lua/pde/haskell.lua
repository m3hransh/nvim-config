if not require("config").pde.haskell then
	return {}
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "haskell" })
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		-- opts = function(_, opts)
		-- 	local nls = require("null-ls")
		-- 	table.insert(opts.sources, nls.builtins.formatting.stylua)
		-- end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				hls = {
					mason = false,
					cmd = { "haskell-language-server-wrapper", "--lsp" },
					settings = {
						haskell = {
							cabalFormattingProvider = "cabalfmt",
							formattingProvider = "ormolu",
						},
					},
				},
			},
		},
	},
	-- Debugging
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "jbyuki/one-small-step-for-vimkind" },
		},
		opts = {},
	},
}
