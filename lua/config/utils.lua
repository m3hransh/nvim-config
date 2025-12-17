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
  local relativepath = vim.fn.fnamemodify(name, ':~:.')
  local ft = vim.bo[b].filetype
  local icon = ''
  local ok, devicons = pcall(require, 'nvim-web-devicons')
  if ok then icon = select(1, devicons.get_icon(filename, ft, { default = true })) or '' end

  local readonly     = vim.bo[b].readonly and '[RO]' or ''
  local unsaved      = (vim.bo[b].modified and name ~= '') and '●' or ''
  local dirty        = git_info()
  local git          = dirty and ' *' or ''

  -- Truncate relativepath if too long
  local max_path_len = 40
  if #relativepath > max_path_len then
    relativepath = '...' .. string.sub(relativepath, -max_path_len)
  end
  -- Get highlight group from theme (use 'Directory' or 'Comment' as example)
  local filepath_hl = '%#Directory#'

  -- Truncate relativepath if too long
  local max_path_len = 60
  if #relativepath > max_path_len then
    relativepath = '...' .. string.sub(relativepath, -max_path_len)
  end

  -- Change color to Comment if buffer is not active
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_win_get_buf(current_win)
  if b ~= current_buf then
    filepath_hl = '%#Comment#'
  end

  -- Apply highlight to filepath
  relativepath   = filepath_hl .. relativepath .. '%*'

  -- left: relative path, right: filename
  local left     = relativepath
  local right_hl = (b ~= current_buf) and '%#Comment#' or '%#Title#' -- Use Comment if not focused
  local right    = right_hl .. table.concat({ unsaved, icon, ' ' .. filename, readonly, git }, ' ') .. '%*'
  return left .. '%=' .. right
end

function M.update_all_winbars()
  local wins = vim.api.nvim_list_wins()
  M.debug_log("Updating winbars for " .. #wins .. " windows")
  for _, win in ipairs(wins) do
    vim.api.nvim_win_call(win, M.set_winbar)
  end
end

-- Get all Mason-installed LSP servers
function M.get_mason_lsp_servers()
    local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
    if not mason_registry_ok then
        return {}
    end

    local installed_servers = {}
    local installed_packages = mason_registry.get_installed_packages()

    for _, pkg in ipairs(installed_packages) do
        -- Check if package is an LSP server
        if pkg.spec.categories and vim.tbl_contains(pkg.spec.categories, "LSP") then
            -- Convert Mason package name to lspconfig server name
            local server_name = pkg.name
            
            -- Handle name mappings between Mason and lspconfig
            local name_map = {
                ["lua-language-server"] = "lua_ls",
                ["typescript-language-server"] = "ts_ls",
                ["html-lsp"] = "html",
                ["css-lsp"] = "cssls",
                ["json-lsp"] = "jsonls",
                ["vue-language-server"] = "volar",
                ["tailwindcss-language-server"] = "tailwindcss",
                ["rust-analyzer"] = "rust_analyzer",
                ["dockerfile-language-server"] = "dockerls",
            }
            
            server_name = name_map[server_name] or server_name
            
            table.insert(installed_servers, server_name)
        end
    end

    return installed_servers
end

-- Get all Mason-installed formatters
function M.get_mason_formatters()
    local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
    if not mason_registry_ok then
        return {}
    end

    local installed_formatters = {}
    local installed_packages = mason_registry.get_installed_packages()

    for _, pkg in ipairs(installed_packages) do
        -- Check if package is a formatter
        if pkg.spec.categories and vim.tbl_contains(pkg.spec.categories, "Formatter") then
            table.insert(installed_formatters, pkg.name)
        end
    end

    return installed_formatters
end

-- Merge explicitly configured servers with Mason-installed ones
function M.get_all_servers(explicit_servers)
    local all_servers = vim.deepcopy(explicit_servers or {})
    local mason_servers = M.get_mason_lsp_servers()
    
    -- Add Mason-installed servers that aren't already in the list
    for _, mason_server in ipairs(mason_servers) do
        if not vim.tbl_contains(all_servers, mason_server) then
            table.insert(all_servers, mason_server)
        end
    end
    
    return all_servers
end

return M
