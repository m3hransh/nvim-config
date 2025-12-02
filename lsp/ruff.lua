return {
  name = 'ruff',
  cmd = { 'ruff', 'server' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
  init_options = {
    settings = {
      logFile = "~/ruff.log",
      logLevel = "debug",
      organizeImports = true,
      fixAll = true,
    }
  },
  on_attach = function(client, _)
    client.server_capabilities.hoverProvider = false
  end,
}
