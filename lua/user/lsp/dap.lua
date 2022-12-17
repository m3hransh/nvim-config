local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
  return
end

local dapui_ok, dapui = pcall(require, "dapui")
if not dapui_ok then
  return
end

local dap_virtual_text_ok, dap_virtual_text = pcall(
  require,
  "nvim-dap-virtual-text"
)
if dap_virtual_text_ok then
  dap_virtual_text.setup {
    commented = true,
  }
end

-- Signs
local dap_breakpoint = {
  breakpoint = {
    text = "🧘",
    texthl = "LspDiagnosticsSignError",
    linehl = "",
    numhl = "",
  },
  rejected = {
    text = "",
    texthl = "LspDiagnosticsSignHint",
    linehl = "",
    numhl = "",
  },
  stopped = {
    text = "🏃",
    texthl = "LspDiagnosticsSignInformation",
    linehl = "DiagnosticUnderlineInfo",
    numhl = "LspDiagnosticsSignInformation",
  },
}

vim.fn.sign_define("DapBreakpoint", dap_breakpoint.breakpoint)
vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

dapui.setup {
  icons = { expanded = "", collapsed = "", circular = "" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  layout = {
    -- You can change the order of elements in the sidebar
    {
      elements = {
        -- Provide as ID strings or tables with "id" and "size" keys
        {
          id = "scopes",
          size = 0.33, -- Can be float or integer > 1
        },
        { id = "breakpoints", size = 0.17 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 0.33,
      position = "right", -- Can be "left", "right", "top", "bottom"
    },
    {
      elements = {
        { id = "repl", size = 0.45 },
        { id = "console", size = 0.55 },
      },
      size = 0.27,
      position = "bottom",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
}
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
--[[ dap.adapters.go = function(callback, _) ]]
--[[   local stdout = vim.loop.new_pipe(false) ]]
--[[   local handle ]]
--[[   local pid_or_err ]]
--[[   local port = 38697 ]]
--[[   local opts = { ]]
--[[     stdio = { nil, stdout }, ]]
--[[     args = { "dap", "-l", "127.0.0.1:" .. port }, ]]
--[[     detached = true, ]]
--[[   } ]]
--[[   handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code) ]]
--[[     stdout:close() ]]
--[[     handle:close() ]]
--[[     if code ~= 0 then ]]
--[[       print("dlv exited with code", code) ]]
--[[     end ]]
--[[   end) ]]
--[[   assert(handle, "Error running dlv: " .. tostring(pid_or_err)) ]]
--[[   stdout:read_start(function(err, chunk) ]]
--[[     assert(not err, err) ]]
--[[     if chunk then ]]
--[[       vim.schedule(function() ]]
--[[         require("dap.repl").append(chunk) ]]
--[[       end) ]]
--[[     end ]]
--[[   end) ]]
--[[   -- Wait for delve to start ]]
--[[   vim.defer_fn(function() ]]
--[[     callback { type = "server", host = "127.0.0.1", port = port } ]]
--[[   end, 100) ]]
--[[ end ]]
--[[ -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md ]]
--[[ dap.configurations.go = { ]]
--[[   { ]]
--[[     type = "go", ]]
--[[     name = "Debug", ]]
--[[     request = "launch", ]]
--[[     program = "${file}", ]]
--[[   }, ]]
--[[   { ]]
--[[     type = "go", ]]
--[[     name = "Debug test", -- configuration for debugging test files ]]
--[[     request = "launch", ]]
--[[     mode = "test", ]]
--[[     program = "${file}", ]]
--[[   }, ]]
--[[   -- works with go.mod packages and sub packages ]]
--[[   { ]]
--[[     type = "go", ]]
--[[     name = "Debug test (go.mod)", ]]
--[[     request = "launch", ]]
--[[     mode = "test", ]]
--[[     program = "./${relativeFileDirname}", ]]
--[[   }, ]]
--[[ } ]]
