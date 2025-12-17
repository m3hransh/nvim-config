local function get_python_path(workspace)
  -- Check for common venv locations
  local venv_patterns = {
    workspace .. '/.venv/bin/python',
    workspace .. '/venv/bin/python',
    workspace .. '/.env/bin/python',
    workspace .. '/env/bin/python',
  }
  for _, path in ipairs(venv_patterns) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  -- Check for poetry
  local poetry_venv = vim.fn.trim(vim.fn.system('cd ' .. workspace .. ' && poetry env info -p 2>/dev/null'))
  if vim.v.shell_error == 0 and poetry_venv ~= '' then
    local poetry_python = poetry_venv .. '/bin/python'
    if vim.fn.executable(poetry_python) == 1 then
      return poetry_python
    end
  end
  -- Check for pipenv
  local pipenv_venv = vim.fn.trim(vim.fn.system('cd ' .. workspace .. ' && pipenv --venv 2>/dev/null'))
  if vim.v.shell_error == 0 and pipenv_venv ~= '' then
    local pipenv_python = pipenv_venv .. '/bin/python'
    if vim.fn.executable(pipenv_python) == 1 then
      return pipenv_python
    end
  end
  return nil
end

return {
  name = 'pylsp',
  cmd = {
    "pylsp",
  },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
  settings = {
    pylsp = {
      plugins = {
        black = { enabled = false },
        autopep8 = { enabled = false },
        pycodestyle = { enabled = false },
        yapf = { enabled = false },
        pylint = { enabled = false },
        pyflakes = { enabled = false },
        jedi = { enabled = false },
        pylsp_mypy = {
          enabled = true,
          report_progress = true,
          live_mode = false,
          overrides = { "--python-executable", vim.NIL, true }
        },
      },
    }
  },
  before_init = function(_, config)
    local root_dir = config.root_dir
    if root_dir then
      local python_path = get_python_path(root_dir)
      if python_path then
        config.settings.pylsp.plugins.jedi = {
          enabled = false,
          environment = python_path,
        }
        config.settings.pylsp.plugins.pylsp_mypy.overrides = {
          "--python-executable", python_path, true
        }
      end
    end
  end,
  on_attach = function(client, bufnr)
    client.server_capabilities.definitionProvider = false
    local root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' }
    local root_dir = vim.fs.dirname(vim.fs.find(root_markers, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })
    [1])

  end,
}
