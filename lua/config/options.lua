local options = {
  formatoptions = "jcroqlnt",
  shortmess = "filnxtToOFWIcC",
  breakindent = true,
  cmdheight = 2,                    -- more space in the neovim command line for displaying messages
  backup = false,                   -- creates a backup file
  clipboard = "unnamedplus",        -- allows neovim to access the system clipboard
  completeopt = "menuone,noselect", -- mostly just for cmp
  conceallevel = 0,                 -- so that `` is visible in markdown files
  fileencoding = "utf-8",           -- the encoding written to a file
  hlsearch = true,                  -- highlight all matches on previous search pattern
  ignorecase = true,                -- ignore case in search patterns
  mouse = "a",                      -- allow the mouse to be used in neovim
  pumblend = 10,
  pumheight = 10,                   -- pop up menu height
  showmode = false,                 -- we don't need to see things like -- INSERT -- anymore
  showtabline = 0,                  -- always show tabs
  smartcase = true,                 -- smart case
  smartindent = true,               -- make indenting smarter again
  splitbelow = true,                -- force all horizontal splits to go below current window
  splitright = true,                -- force all vertical splits to go to the right of current window
  swapfile = false,                 -- creates a swapfile
  -- laststatus = 3, -- make status line global
  -- termguicolors = true,                    -- set term gui colors (most terminals support this)
  timeoutlen = 200,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,                         -- enable persistent undo
  updatetime = 300,                        -- faster completion (4000ms default)
  writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,                        -- convert tabs to spaces
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  tabstop = 2,                             -- insert 2 spaces for a tab
  cursorline = true,                       -- highlight the current line
  number = true,                           -- set numbered lines
  relativenumber = true,                   -- set relative numbered lines
  numberwidth = 4,                         -- set number column width to 2 {default 4}
  signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
  wrap = false,                            -- display lines as one long line
  scrolloff = 8,                           -- is one of my fav
  sidescrolloff = 8,
  guifont = "JetBrainsMono Nerd Font:h16", -- the font used in graphical neovim applications
  conceallevel = 1,
}

vim.opt.shortmess:append("c")

for k, v in pairs(options) do
  vim.opt[k] = v
end
-- Theme
vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = true
vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }

vim.g.instant_username = "m3hransh"
-- Change the "hint" color to the "orange" color, and make the "error" color bright red
vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000" }

-- skip backwards compatibility routines and speed up loading.
vim.g.skip_ts_context_commentstring_module = true

vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_theme = 'dark'
vim.g.neovide_opacity = 0.8
vim.g.neovide_background_color = "#16161e"
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

-- auto close nvim tree
-- vim.api.nvim_create_autocmd("BufEnter", {
--   nested = true,
--   callback = function()
--     if
--       #vim.api.nvim_list_wins() == 1
--       and vim.api.nvim_buf_get_name(0):match "NvimTree_" ~= nil
--     then
--       vim.cmd "quit"
--     end
--   end,
-- })

vim.cmd([[ command! Exec execute 'set splitright | vnew | set filetype=sh | read !sh #' ]])
vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]]) -- TODO: this doesn't seem to work

-- clear winhighlight (affects current window)
vim.wo.winhighlight = ''
-- or set your own mapping and style the targets
vim.wo.winhighlight = 'WinBar:MyWinBar,WinBarNC:MyWinBarNC'
vim.api.nvim_set_hl(0, 'MyWinBar', { fg = '#ffffff', bg = '#1a1b26', bold = true })
vim.api.nvim_set_hl(0, 'MyWinBarNC', { fg = '#666666', bg = '#1a1b26' })

vim.o.winbar = "%{%v:lua.require('config.utils').set_winbar()%}"
