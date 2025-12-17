return {
    cmd = { "rust-analyzer" },
    root_markers = { "Cargo.lock" },
    filetypes = { "rust" },
    settings = {
        ["rust-analyzer"] = {
            check = {
                command = "clippy",
            },
            diagnostics = {
                enable = true,
            },
        },
    },
  on_attach = function(client, bufnr)
    local ok_navbuddy, navbuddy = pcall(require, "nvim-navbuddy")

    if ok_navbuddy then
      navbuddy.attach(client, bufnr)
    end
  end,
}
