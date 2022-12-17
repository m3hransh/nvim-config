local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)
    if hide_width and win_width < hide_width then
      return ""
    elseif
      trunc_width
      and trunc_len
      and win_width < trunc_width
      and #str > trunc_len
    then
      return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
    end
    return str
  end
end

local custom_fname = require("lualine.components.filename"):extend()
local highlight = require "lualine.highlight"
local default_status_colors = { saved = "#228B22", modified = "#C70039" }

local status_colors, colors = pcall(require, "tokyonight.colors")

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
  symbols = { error = " ", warn = " " },
  colored = false,
  update_in_insert = false,
  always_visible = true,
}

local diff = {
  "diff",
  colored = false,
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width,
}

local mode = {
  "mode",
  fmt = function(str)
    return "-- " .. str .. " --"
  end,
  separator = { right = "" },
}

local filetype = {
  "filetype",
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
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
    globalstatus = true,
  },
  sections = {
    lualine_a = { branch, diagnostics },
    lualine_b = {
      mode,
      { custom_fname, separator = { left = "", right = "" } },
    },
    lualine_c = {},
    lualine_x = {
      diff,
      { spaces, fmt = trunc(90, 30, 90) },
      { "encoding", fmt = trunc(90, 30, 90) },
      filetype,
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { custom_fname },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}
