return {
  name = 'lua_ls',
  cmd = { 'lua-language-server' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
  filetypes = { 'lua' },
  settings = {
    Lua = {}
  },
  on_attach = function(client, bufnr)
    local ok_navbuddy, navbuddy = pcall(require, "nvim-navbuddy")

    if ok_navbuddy then
      navbuddy.attach(client, bufnr)
    end
  end,
}
