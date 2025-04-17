-- ~/.config/nvim/lua/overseer/template/checkmk/f12.lua
local function strip(s)
  return s:match("^%s*(.-)%s*$")
end

local function version_to_name(s)
  return "v" .. s:match("^[^%-]*"):gsub("%.", "")
end

return {
  name = "f12",
  desc = "Run `f12` with SITE env var from current file directory",

  params = function()
    local stdout = vim.system({ "omd", "version", "-b" }):wait().stdout
    print(stdout)
    return {
      site = {
        type = "string",
        -- Optional fields that are available on any type
        name = "Site name",
        desc = "Site to refelect the change",
        order = 1, -- determines order of parameters in the UI
        optional = false,
        default = version_to_name(strip(stdout)),
        -- For component params only.
        -- When true, will default to the value in the task's default_component_params
        default_from_task = true,
      }
    }
  end,
  builder = function(params)
    local dir = vim.fn.expand("%:p:h")
    return {
      cmd = { "f12" },
      cwd = dir,
      env = {
        SITE = params.site,
      },
      components = {
        { "on_output_quickfix", open = true },
        "default",
      },
    }
  end,
}
