return {
    name = 'pylsp',
    cmd = { 'pylsp' },
    filetypes= { 'python' },
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
          pylsp_mypy = { enabled = true, report_progress = true, live_mode = false },
        },
      }
    },
    on_attach = function(client, _)
       client.server_capabilities.definitionProvider = false
    end,
  }
