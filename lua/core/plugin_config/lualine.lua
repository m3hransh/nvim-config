local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local window_width_limit = 100

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand "%:t") ~= 1
  end,
  hide_in_width = function()
    return vim.o.columns > window_width_limit
  end,
  -- check_git_workspace = function()
  --   local filepath = vim.fn.expand "%:p:h"
  --   local gitdir = vim.fn.finddir(".git", filepath .. ";")
  --   return gitdir and #gitdir > 0 and #gitdir < #filepath
  -- end,
}

local icons = require('core.icons')

local status_colors, colors = pcall(require, "tokyonight.colors")
if not status_colors then
  colors = {
    bg = "#202328",
    fg = "#bbc2cf",
    yellow = "#ECBE7B",
    cyan = "#008080",
    darkblue = "#081633",
    green = "#98be65",
    orange = "#FF8800",
    violet = "#a9a1e1",
    magenta = "#c678dd",
    purple = "#c678dd",
    blue = "#51afef",
    red = "#ec5f67",
  }
end

local custom_fname = require("lualine.components.filename"):extend()
local highlight = require "lualine.highlight"
local default_status_colors = { saved = "#228B22", modified = "#C70039" }


if status_colors then
  colors = colors.setup()
  default_status_colors.saved = colors.git.change
  default_status_colors.modified = colors.git.add
  default_status_colors.fg = colors.fg
end

function custom_fname:init(options)
  custom_fname.super.init(self, options)
  self.status_colors = {
    saved = highlight.create_component_highlight_group(
      { bg = default_status_colors.saved, fg = default_status_colors.fg },
      "filename_status_saved",
      self.options
    ),
    modified = highlight.create_component_highlight_group({
      bg = default_status_colors.modified,
      fg = default_status_colors.fg,
    }, "filename_status_modified", self.options),
  }
  if self.options.color == nil then
    self.options.color = ""
  end
end

function custom_fname:update_status()
  local data = custom_fname.super.update_status(self)
  data = highlight.component_format_highlight(
    vim.bo.modified and self.status_colors.modified
    or self.status_colors.saved
  ) .. data
  return data
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = {
    error = icons.diagnostics.BoldError .. " ",
    warn = icons.diagnostics.BoldWarning .. " ",
    info = icons.diagnostics.BoldInformation .. " ",
    hint = icons.diagnostics.BoldHint .. " ",
  },
}
local lsp = {
  function(msg)
    msg = msg or "LS Inactive"
    local buf_clients = vim.lsp.get_active_clients()
    if next(buf_clients) == nil then
      -- TODO: clean up this if statement
      if type(msg) == "boolean" or #msg == 0 then
        return "LS Inactive"
      end
      return msg
    end
    local buf_ft = vim.bo.filetype
    local buf_client_names = {}
    local copilot_active = false

    -- add client
    for _, client in pairs(buf_clients) do
      if client.name ~= "null-ls" and client.name ~= "copilot" then
        table.insert(buf_client_names, client.name)
      end

      if client.name == "copilot" then
        copilot_active = true
      end
    end

    -- add formatter
    --[[ local formatters = require "lvim.lsp.null-ls.formatters" ]]
    --[[ local supported_formatters = formatters.list_registered(buf_ft) ]]
    --[[ vim.list_extend(buf_client_names, supported_formatters) ]]
    --[[]]
    --[[ -- add linter ]]
    --[[ local linters = require "lvim.lsp.null-ls.linters" ]]
    --[[ local supported_linters = linters.list_registered(buf_ft) ]]
    --[[ vim.list_extend(buf_client_names, supported_linters) ]]

    local unique_client_names = vim.fn.uniq(buf_client_names)

    local language_servers = "[" .. table.concat(unique_client_names, ", ") .. "]"

    if copilot_active then
      language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*"
    end

    return language_servers
  end,
  color = { gui = "bold" },
  cond = conditions.hide_in_width,
}
local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local diff = {
  "diff",
  source = diff_source,
  symbols = {
    added = icons.git.LineAdded .. " ",
    modified = icons.git.LineModified .. " ",
    removed = icons.git.LineRemoved .. " ",
  },
  padding = { left = 2, right = 1 },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.yellow },
    removed = { fg = colors.red },
  },
  cond = nil,
}

local mode = {
  function()
    return " " .. icons.ui.Target .. " "
  end,
  padding = { left = 0, right = 0 },
  color = {},
  cond = nil,
}

local filetype = {
  "filetype",
}

local branch = {
  "b:gitsigns_head",
  icon = icons.git.Branch,
  color = { gui = "bold" }
}

local spaces = function()
  return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

lualine.setup {
  options = {
    icons_enabled = true,
    theme = "auto",
    disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
    always_divide_middle = true,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    globalstatus = true,
  },
  sections = {
    lualine_a = { mode },
    lualine_b = { branch },
    lualine_c = { diff },
    lualine_x = {
      diagnostics,
      lsp,
      filetype,
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { custom_fname },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}
