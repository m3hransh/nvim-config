return {
  name = 'starpls',
  cmd = { 'starpls' },
  filetypes = { "bzl" },
  root_markers = { "WORKSPACE", "WORKSPACE.bazel", "MODULE.bazel", ".git" },
  init_options = {
    settings = {
      logFile = "~/bazel.log",
      logLevel = "debug",
    }
  },
}
