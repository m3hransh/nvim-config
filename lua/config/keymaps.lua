local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

local function conf(new_opts)
  return vim.tbl_extend("force", opts, new_opts)
end
-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Better viewing
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")
keymap("n", "g,", "g,zvzz")
keymap("n", "g;", "g;zvzz")

-- Better escape using jk in insert and terminal mode
keymap("i", "jk", "<ESC>")
keymap("t", "jk", "<C-\\><C-n>")
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h")
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j")
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k")
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l")

-- Add undo break-points
keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")

-- Better indent
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Paste over currently selected text without yanking it
keymap("v", "p", '"_dP')

-- Move Lines
keymap("n", "<A-j>", ":m .+1<CR>==")
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv")
keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
keymap("n", "<A-k>", ":m .-2<CR>==")
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv")
keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi")

-- Resize window using <shift> arrow keys
keymap("n", "<S-Up>", "<cmd>resize +2<CR>")
keymap("n", "<S-Down>", "<cmd>resize -2<CR>")
keymap("n", "<S-Left>", "<cmd>vertical resize -2<CR>")
keymap("n", "<S-Right>", "<cmd>vertical resize +2<CR>")

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Map Ctrl+S to save in any mode
keymap("n", "<C-S>", ":update<CR>", opts)
keymap("v", "<C-S>", "<C-C>:update<CR>", opts)
keymap("i", "<C-S>", "<C-O>:update<CR>", opts)

keymap("n", "<leader>x", ":q!<CR>", conf({ desc = "Quit" }))
keymap("n", "<leader>X", ":qa!<CR>", conf({ desc = "Quit All" }))
keymap("n", "<leader>c", ":Bdelete!<CR>", conf({ desc = "Close Buffer" }))
keymap("n", "<leader>h", ":nohlsearch<CR>", conf({ desc = "No Highlight" }))

-- Switch between the last two files
keymap("n", "<leader><leader>", "<c-^>", opts)

vim.keymap.set('n', '<leader>u', function()
  local file_dir = vim.fn.expand('%:p:h')
  local cmd = { 'f12' } -- like { "npm", "run", "dev" }

  local task_buf_name = '__TaskRunner__'
  local task_buf = nil
  local task_win = nil

  -- Check if the buffer exists
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    local short_name = vim.fn.fnamemodify(name, ":t") -- get only the tail (filename)
    if short_name == task_buf_name then
      task_buf = buf
      break
    end
  end

  -- Save current window to return focus to it later
  local original_win = vim.api.nvim_get_current_win()

  -- If the buffer doesn’t exist, create it
  if not task_buf then
    task_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(task_buf, task_buf_name)
    vim.bo[task_buf].buftype = 'nofile'
    vim.bo[task_buf].bufhidden = 'hide'
    vim.bo[task_buf].swapfile = false
    vim.api.nvim_buf_set_keymap(task_buf, 'n', 'q', '<cmd>hide<CR>', { noremap = true, silent = true })
  end

  -- Open the buffer in a new bottom split only if it’s not visible
  local is_open = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == task_buf then
      is_open = true
      task_win = win
      break
    end
  end

  if not is_open then
    vim.cmd('botright split')
    vim.cmd('resize 15')
    task_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(task_win, task_buf)
  end

  -- Go back to the original window
  vim.api.nvim_set_current_win(original_win)

  -- Clear previous output
  vim.api.nvim_buf_set_option(task_buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(task_buf, 0, -1, false, {})
  vim.api.nvim_buf_set_option(task_buf, 'modifiable', false)

  -- Start the job and stream output
  vim.fn.jobstart(cmd, {
    cwd = file_dir,
    stdout_buffered = false,
    stderr_buffered = false,
    on_stdout = function(_, data)
      if data then
        vim.api.nvim_buf_set_option(task_buf, 'modifiable', true)
        vim.api.nvim_buf_set_lines(task_buf, -1, -1, false, data)
        vim.api.nvim_buf_set_option(task_buf, 'modifiable', false)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.api.nvim_buf_set_option(task_buf, 'modifiable', true)
        vim.api.nvim_buf_set_lines(task_buf, -1, -1, false, data)
        vim.api.nvim_buf_set_option(task_buf, 'modifiable', false)
      end
    end,
    on_exit = function()
      vim.api.nvim_buf_set_option(task_buf, 'modifiable', true)
      vim.api.nvim_buf_set_lines(task_buf, -1, -1, false, { '', '[Process completed]' })
      vim.api.nvim_buf_set_option(task_buf, 'modifiable', false)
    end,
  })
end, { desc = 'Stream command output in bottom split without affecting current buffer' })
