-- lua/config/utils.lua
local M = {}

local cache_dir = vim.fn.stdpath('cache')
if vim.fn.isdirectory(cache_dir) == 0 then
  pcall(vim.fn.mkdir, cache_dir, 'p')
end

-- Pick your desired filename here via plugin name
local plugin_name = 'nvim_debug' -- -> ~/.cache/nvim/nvim_debug.log

local log
local ok, plog = pcall(require, 'plenary.log')
if ok then
  log = plog.new({
    plugin = plugin_name, -- file: ~/.cache/nvim/nvim_debug.log
    level = 'debug',      -- or vim.log.levels.DEBUG
    use_console = false,  -- don't echo to :messages
  })
else
  -- Fallback logger that writes to the same file
  local file = cache_dir .. '/' .. plugin_name .. '.log'
  log = {
    debug = function(message)
      local ts = os.date('%Y-%m-%d %H:%M:%S')
      local line = string.format('[%s] [DEBUG] %s\n', ts, tostring(message))
      vim.fn.writefile({ line }, file, 'a')
    end,
  }
end

-- Write a line immediately so the file appears
pcall(function() log.debug('logger initialized') end)

function M.debug_log(message)
  -- IMPORTANT: keep the method receiver (self)
  local ok2, err = pcall(function()
    log.debug(message)
  end)
  if not ok2 then
    -- Only prints if something truly failed (e.g. permissions)
    print('ERROR: Failed to write to log file: ' .. tostring(err))
  end
end

local function git_info()
  -- Provided by gitsigns (if loaded and buffer is in a repo)
  local d = vim.b.gitsigns_status_dict
  if not d then return '', false end
  return (d.added or 0) > 0 or (d.changed or 0) > 0 or (d.removed or 0) > 0
end

function M.set_winbar()
  local w = vim.api.nvim_get_current_win()
  local b = vim.api.nvim_win_get_buf(w)
  local name = vim.api.nvim_buf_get_name(b)
  local bt = vim.bo[b].buftype
  if name == '' or bt ~= '' or name:match('oil://') or name:match('fugitive://') then
    return ''
  end

  local filename = vim.fn.fnamemodify(name, ':t')
  local ft = vim.bo[b].filetype
  local icon = ''
  local ok, devicons = pcall(require, 'nvim-web-devicons')
  if ok then icon = select(1, devicons.get_icon(filename, ft, { default = true })) or '' end

  local readonly = vim.bo[b].readonly and '[RO]' or ''
  local unsaved  = (vim.bo[b].modified and name ~= '') and '●' or ''

  local dirty    = git_info()
  local git      = dirty and ' *' or ''

  return table.concat({ ' ', unsaved, icon, ' ' .. filename, readonly, git }, ' ')
end

function M.update_all_winbars()
  local wins = vim.api.nvim_list_wins()
  M.debug_log("Updating winbars for " .. #wins .. " windows")
  for _, win in ipairs(wins) do
    vim.api.nvim_win_call(win, M.set_winbar)
  end
end

return M
