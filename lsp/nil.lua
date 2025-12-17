return {
  name="nil",
  cmd={"nil" },
  filetypes={ "nix"},
  root_markers={ "flake.nix", "shell.nix", ".git" },
  on_attach = function(client, bufnr)
    local ok_navbuddy, navbuddy = pcall(require, "nvim-navbuddy")

    if ok_navbuddy then
      navbuddy.attach(client, bufnr)
    end
  end,
  }
