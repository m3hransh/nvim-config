local M = {}

local function configure()
  local icons = require('core.icons')
  local dap_breakpoint = {
    error = {
      text = icons.diagnostics.Debug,
      texthl = "LspDiagnosticsSignError",
      linehl = "",
      numhl = "",
    },
    rejected = {
      text = icons.diagnostics.Warning,
      texthl = "LspDiagnosticsSignHint",
      linehl = "",
      numhl = "",
    },
    stopped = {
      text = icons.diagnostics.Information,
      texthl = "LspDiagnosticsSignInformation",
      linehl = "DiagnosticUnderlineInfo",
      numhl = "LspDiagnosticsSignInformation",
    },
  }

  vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
  vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
  vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)
end

local function configure_exts()
  local dap_ok, dap = pcall(require, 'dap')
  local dapui_ok, dapui = pcall(require, 'dapui')

  if not dapui_ok or not dap_ok then
    return
  end

  dapui.setup {}

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open {}
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close {}
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close {}
  end
  local dap_virtual_text_ok, dap_virtual_text = pcall(require, 'nvim-dap-virtual-text')
  if not dap_virtual_text_ok then
    return
  end
  dap_virtual_text.setup {
    commented = true,
  }
end

local function configure_debuggers()
  --[[ require("config.dap.lua").setup() ]]
  --[[ require("config.dap.python").setup() ]]
  --[[ require("config.dap.rust").setup() ]]
  --[[ require("config.dap.go").setup() ]]
end

configure() -- Configuration
configure_exts() -- Extensions
configure_debuggers() -- Debugger
require("core.dap.keymaps").setup() -- Keymaps


return M
