return {
  "goolord/alpha-nvim",
  lazy = false,
  keys = {
    { "<leader>a", "<cmd>Alpha<cr>", desc = "Find Files" } },
  config = function()
    local dashboard = require "alpha.themes.dashboard"
    local icons = require("config.icons")
    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     "
    }
    dashboard.section.buttons.val = {
      dashboard.button("f", icons.ui.Files .. " Find file", ":Telescope find_files <CR>"),
      dashboard.button("n", icons.ui.File .. " New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("r", icons.ui.History .. " Recent files", ":Telescope oldfiles <CR>"),
      dashboard.button("g", icons.ui.List .. " Find text", ":Telescope live_grep <CR>"),
      dashboard.button("c", icons.ui.Gear .. " Config", ":e $MYVIMRC <CR>"),
      dashboard.button("l", icons.ui.Sleep .. " Lazy", ":Lazy<CR>"),
      dashboard.button("q", icons.ui.SignOut .. " Quit", ":qa<CR>"),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end
    dashboard.section.footer.opts.hl = "Constant"
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.opts.layout[1].val = 0

    if vim.o.filetype == "lazy" then
      -- close and re-open Lazy after showing alpha
      vim.notify("Missing plugins installed!", vim.log.levels.INFO, { title = "lazy.nvim" })
      vim.cmd.close()
      require("alpha").setup(dashboard.opts)
      require("lazy").show()
    else
      require("alpha").setup(dashboard.opts)
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

        -- local now = os.date "%d-%m-%Y %H:%M:%S"
        local version = "   v" .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
        local fortune = require "alpha.fortune"
        local quote = table.concat(fortune(), "\n")
        local plugins = "⚡Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
        local footer = "\t" .. version .. "\t" .. plugins .. "\n" .. quote
        -- dashboard.section.footer.val = footer
        -- pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
