return {
  name = "jsonls",
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  settings = {
    json = {
      schemas = {},
      validate = { enable = true },
    },
  },
}
