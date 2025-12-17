return {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        diagnosticSeverityOverrides = {
          reportTypedDictNotRequiredAccess = "none",
          reportPossiblyUnboundVariable = "warning"
        },
        exclude = {
          "**/bazel-*/**",
          "**/.bazel/**",
          "**/bazel-bin/**",
          "**/bazel-out/**",
          "**/bazel-testlogs/**",
          "**/node_modules/**",
          "**/.venv/**",
          "**/__pycache__/**",
        },
        autoSearchPaths = true,
        useLibraryCodeForTypes = false,
        stubPath = "",
      },
    },
  },
  on_attach = function(client, bufnr)
    local ok_navbuddy, navbuddy = pcall(require, "nvim-navbuddy")

    if ok_navbuddy then
      navbuddy.attach(client, bufnr)
    end

    local root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' }
    local root_dir = vim.fs.dirname(vim.fs.find(root_markers, { path = vim.api.nvim_buf_get_name(0), upward = true })[1])

    local is_checkmk = root_dir:match("checkmk")
    if is_checkmk then
       -- Disable diagnostics for Pyright in checkmk
       client.handlers["textDocument/publishDiagnostics"] = function() end
    end
  end,
}
