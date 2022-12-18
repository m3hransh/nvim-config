local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

M = {}

local opts = { noremap = true, silent = true }

local function conf(new_opts)
  return vim.tbl_extend("force", opts, new_opts)
end
-- local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "<leader>a", ":Alpha<CR>", conf { desc = "Alpha" })
keymap(
  "n",
  "<leader>f",
  "<cmd>lua require('telescope.builtin').find_files("
    .. "vim.tbl_deep_extend('force', require('telescope.themes').get_dropdown{previewer = false},"
    .. "{find_command = {'rg', '--files', '--hidden', '-g', '!.git' }}))<CR>",
  conf { desc = "Find Files" }
)
keymap(
  "n",
  "<leader>F",
  "<cmd>lua require('telescope.builtin').live_grep("
    .. "vim.tbl_deep_extend('force', require('telescope.themes').get_ivy(),"
    .. "{find_command = {'rg', '--files', '--hidden', '-g', '!.git' }}))<CR>",
  conf { desc = "Find Files" }
)
keymap(
  "n",
  "<leader>P",
  "<cmd>lua require('telescope').extensions.projects.projects()<cr>",
  conf { desc = "Projects" }
)
keymap(
  "n",
  "<leader>b",
  "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
  conf { desc = "Buffers" }
)
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", conf { desc = "Explorer" })
keymap("n", "<leader>x", ":q!<CR>", conf { desc = "Quit" })
keymap("n", "<leader>X", ":qa!<CR>", conf { desc = "Quit All" })
keymap("n", "<leader>c", ":Bdelete!<CR>", conf { desc = "Close Buffer" })
keymap("n", "<leader>h", ":nohlsearch<CR>", conf { desc = "No Highlight" })

-- Navigate properly when lines are wrapped
keymap("n", "k", "gk", opts)
keymap("n", "j", "gj", opts)

-- Map Ctrl+S to save in any mode
keymap("n", "<C-S>", ":update<CR>", opts)
keymap("v", "<C-S>", "<C-C>:update<CR>", opts)
keymap("i", "<C-S>", "<C-O>:update<CR>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Switch between the last two files
keymap("n", "<leader><leader>", "<c-^>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "p", '"_dP', conf { desc = "replace selected area with reg" })

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Packer
keymap("n", "<leader>pc", ":PackerCompile<CR>", conf { desc = "Compile" })
keymap(
  "n",
  "<leader>pi",
  "<cmd>PackerInstall<cr>",
  conf { desc = "Install" }
)
keymap("n", "<leader>ps", ":PackerSync<CR>", conf { desc = "Sync" })
keymap(
  "n",
  "<leader>pS",
  "<cmd>PackerStatus<cr>",
  conf { desc = "Status" }
)
keymap(
  "n",
  "<leader>pu",
  "<cmd>PackerUpdate<cr>",
  conf { desc = "Update" }
)

-- Search
keymap(
  "n",
  "<leader>sb",
  "<cmd>Telescope git_branches<cr>",
  conf { desc = "Checkout Branch" }
)
keymap(
  "n",
  "<leader>sc",
  "<cmd>Telescope colorscheme<cr>",
  conf { desc = "Colorscheme" }
)
keymap(
  "n",
  "<leader>sh",
  "<cmd>Telescope help_tags<cr>",
  conf { desc = "Find Help" }
)
keymap(
  "n",
  "<leader>sM",
  "<cmd>Telescope man_pages<cr>",
  conf { desc = "Man Pages" }
)
keymap(
  "n",
  "<leader>sr",
  "<cmd>Telescope oldfiles<cr>",
  conf { desc = "Open Recent file" }
)
keymap(
  "n",
  "<leader>sR",
  "<cmd>Telescope registers<cr>",
  conf { desc = "Open Recent file" }
)
keymap(
  "n",
  "<leader>sk",
  "<cmd>Telescope keymaps<cr>",
  conf { desc = "Keymaps" }
)
keymap(
  "n",
  "<leader>sC",
  "<cmd>Telescope commands<cr>",
  conf { desc = "Commands" }
)

-- Git
keymap(
  "n",
  "<leader>gg",
  "<cmd>lua _LAZYGIT_TOGGLE()<CR>",
  conf { desc = "Lazygit" }
)
keymap(
  "n",
  "<leader>gj",
  "<cmd>lua require 'gitsigns'.next_hunk()<cr>",
  conf { desc = "Next Hunk" }
)
keymap(
  "n",
  "<leader>gk",
  "<cmd>lua require 'gitsigns'.prev_hunk()<cr>",
  conf { desc = "Prev Hunk" }
)
keymap(
  "n",
  "<leader>gl",
  "<cmd>lua require 'gitsigns'.blame_line()<cr>",
  conf { desc = "Blame" }
)
keymap(
  "n",
  "<leader>gp",
  "<cmd>lua require 'gitsigns'.preview_hunk()<cr>",
  conf { desc = "Preview Hunk" }
)
keymap(
  "n",
  "<leader>gr",
  "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",
  conf { desc = "Reset Hunk" }
)
keymap(
  "n",
  "<leader>gR",
  "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",
  conf { desc = "Reset Buffer" }
)
keymap(
  "n",
  "<leader>gs",
  "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",
  conf { desc = "Stage Hunk" }
)
keymap(
  "n",
  "<leader>gS",
  "<cmd>lua require 'gitsigns'.stage_buffer()<cr>",
  conf { desc = "Stage Buffer" }
)
keymap(
  "n",
  "<leader>gu",
  "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
  conf { desc = "Undo Stage Hunk" }
)
keymap(
  "n",
  "<leader>gU",
  "<cmd>lua require 'gitsigns'.reset_buffer_index()<cr>",
  conf { desc = "Undo Buffer Stage" }
)
keymap(
  "n",
  "<leader>go",
  "<cmd>Telescope git_status<cr>",
  conf { desc = "Open Changed Files" }
)
keymap(
  "n",
  "<leader>gb",
  "<cmd>Telescope git_branches<cr>",
  conf { desc = "Checkout Branchs" }
)
keymap(
  "n",
  "<leader>gc",
  "<cmd>Telescope git_commits<cr>",
  conf { desc = "Checkout Commits" }
)
keymap(
  "n",
  "<leader>gD",
  "<cmd>Gitsigns diffthis HEAD<cr>",
  conf { desc = "Diff" }
)

-- Terminal
keymap(
  "n",
  "<leader>tn",
  "<cmd>lua _NODE_TOGGLE()<cr>",
  conf { desc = "Node" }
)
keymap(
  "n",
  "<leader>tu",
  "<cmd>lua _NCDU_TOGGLE()<cr>",
  conf { desc = "NCDU" }
)
keymap(
  "n",
  "<leader>tf",
  "<cmd>ToggleTerm direction=float<cr>",
  conf { desc = "Float" }
)
keymap(
  "n",
  "<leader>th",
  "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
  conf { desc = "Horizontal Terminal" }
)
keymap(
  "n",
  "<leader>tv",
  "<cmd>ToggleTerm size=80 direction=vertical<cr>",
  conf { desc = "Vertical Terminal" }
)
keymap(
  "n",
  "<leader>tg",
  "<cmd>exe 'silent !kitty --detach --directory \"' . getcwd() . '\" lazygit'<cr>",
  conf { desc = "Lazygit" }
)
keymap(
  "n",
  "<leader>te",
  "<cmd>exe 'silent !kitty --detach --directory \"' . getcwd() . '\"'<cr>",
  conf { desc = "External Terminal" }
)

-- Refactoring
-- Remaps for the refactoring operations currently offered by the plugin
vim.api.nvim_set_keymap(
  "v",
  "<leader>re",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
  conf { desc = "Extract Function" }
)
vim.api.nvim_set_keymap(
  "v",
  "<leader>rf",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
  conf { desc = "Extract Function To File" }
)
vim.api.nvim_set_keymap(
  "v",
  "<leader>rr",
  [[ <Esc><Cmd>lua require('telescope').extensions.refactoring.refactors()<CR>]],
  conf { desc = "Extract Function To File" }
)
vim.api.nvim_set_keymap(
  "v",
  "<leader>rv",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
  { noremap = true, silent = true, expr = false }
)
vim.api.nvim_set_keymap(
  "v",
  "<leader>ri",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
  { noremap = true, silent = true, expr = false }
)

-- Extract block doesn't need visual mode
vim.api.nvim_set_keymap(
  "n",
  "<leader>rb",
  [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
  { noremap = true, silent = true, expr = false }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>rbf",
  [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
  { noremap = true, silent = true, expr = false }
)

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
vim.api.nvim_set_keymap(
  "n",
  "<leader>ri",
  [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
  { noremap = true, silent = true, expr = false }
)
-- LSP

local map = vim.api.nvim_buf_set_keymap

-- Conditional mapping based on server_capabilities
local function map_cond(cap, b, m, key, cmd)
  if cap then
    map(b, m, key, cmd, opts)
  end
end

local function which_cond(dict, cap, key, rhs, desc)
  if cap then
    dict[key] = { rhs, desc }
  end
end

M.lsp_keymaps = function(client, bufnr)
  local rc = client.server_capabilities
  -- vim.pretty_print(rc)

  -- Goto
  local which_keymaps = {
    name = "Goto",
    l = {
      name = "LSP",
      i = { "<cmd>LspInfo<cr>", "LSP Info" },
      I = { "<cmd>LspInstallInfo<cr>", "LSP Installer Info" },
      c = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Actions" },
      l = { "<cmd>Telescope diagnostics<CR>", "Diagnostics List" },
      d = {
        '<cmd>lua vim.diagnostic.open_float({border ="rounded" })<CR>',
        "Show Diagnostc",
      },
      q = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "Quickfix" },
    },
  }
  which_cond(
    which_keymaps,
    rc.declarationProvider,
    "D",
    "<cmd>lua vim.lsp.buf.declaration()<CR>",
    "Goto Declaration"
  )
  which_cond(
    which_keymaps,
    rc.definitionProvider,
    "d",
    "<cmd>lua vim.lsp.buf.definition()<CR>",
    "Goto Definition"
  )
  which_cond(
    which_keymaps,
    rc.implementationProvider,
    "i",
    "<cmd>lua vim.lsp.buf.implementation()<CR>",
    "Goto Implementation"
  )
  which_cond(
    which_keymaps,
    rc.typeDefinitionProvider,
    "t",
    "<cmd>lua vim.lsp.buf.type_definition()<CR>",
    "Goto Type Definition"
  )

  -- Help
  map_cond(
    rc.hoverProvider,
    bufnr,
    "n",
    "K",
    "<cmd>lua vim.lsp.buf.hover()<CR>",
    conf { "Hover" }
  )
  map_cond(
    rc.signatureHelpProvider,
    bufnr,
    "n",
    "<C-k>",
    "<cmd>lua vim.lsp.buf.signature_help()<CR>",
    conf { "Signature Help" }
  )

  -- Code
  which_cond(
    which_keymaps.l,
    rc.codeActionProvider,
    "a",
    "<cmd>lua vim.lsp.buf.code_action()<CR>",
    "Code Actions"
  )
  which_cond(
    which_keymaps.l,
    true,
    "f",
    "<cmd>lua vim.lsp.buf.format { async=false }<CR>",
    "Format"
  )
  which_cond(
    which_keymaps.l,
    rc.referencesProvider,
    "r",
    "<cmd>Telescope lsp_references<CR>",
    "References"
  )
  which_cond(
    which_keymaps.l,
    rc.renameProvider,
    "R",
    "<cmd>lua vim.lsp.buf.rename()<CR>",
    "Rename"
  )
  which_cond(
    which_keymaps.l,
    rc.documentSymbolProvider,
    "s",
    "<cmd>Telescope lsp_document_symbols<cr>",
    "Document Symbols"
  )
  which_cond(
    which_keymaps.l,
    rc.workspaceSymbolProvider,
    "S",
    "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
    "Workspace Symbols"
  )
  which_key.register(
    which_keymaps,
    { buffer = bufnr, prefix = "g", nowait = false, noremap = true }
  )

  -- Diagnostics
  map(
    bufnr,
    "n",
    "[d",
    '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>',
    opts
  )
  map(
    bufnr,
    "n",
    "]d",
    '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>',
    opts
  )
  -- Workspace
  map(
    bufnr,
    "n",
    "<leader>wa",
    "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
    opts
  )
  map(
    bufnr,
    "n",
    "<leader>wr",
    "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
    opts
  )
  map(
    bufnr,
    "n",
    "<leader>wl",
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    opts
  )

  -- Debugging
  keymap(
    "n",
    "<leader>dc",
    "<cmd>Telescope dap commands<cr>",
    conf { desc = "Vertical Terminal" }
  )
  if client.name == "gopls" then
    -- Go plugin already added debugging keymaps
    map(bufnr, "n", "<leader>dd", "<cmd>GoDebug<CR>", opts)
    map(bufnr, "n", "<leader>db", "<cmd>GoBreakToggle<CR>", opts)
    map(bufnr, "n", "<leader>ds", "<cmd>GoDebug -s<CR>", opts)
    -- For other languages
  else
    map(
      bufnr,
      "n",
      "<leader>dd",
      "<cmd>lua require'dapui'.toggle()<CR>",
      conf { desc = "Open Debugging" }
    )
    map(
      bufnr,
      "n",
      "<leader>db",
      "<cmd>lua require'dap'.toggle_breakpoint()<CR>",
      conf { desc = "Toggle Breakpoint" }
    )
    map(
      bufnr,
      "n",
      "<leader>dg",
      "<cmd>lua require'dap'.continue()<CR>",
      conf { desc = "Continue" }
    )
    map(
      bufnr,
      "n",
      "<leader>dn",
      "<cmd>lua require'dap'.step_over()<CR>",
      conf { desc = "Step Over" }
    )
    map(
      bufnr,
      "n",
      "<leader>di",
      "<cmd>lua require'dap'.step_into()<CR>",
      conf { desc = "Step Into" }
    )
    map(
      bufnr,
      "n",
      "<leader>do",
      "<cmd>lua require'dap'.step_out()<CR>",
      conf { desc = "Step Out" }
    )
    map(
      bufnr,
      "n",
      "<leader>ds",
      "<cmd>lua require'dap'.close()<CR>",
      conf { desc = "Close Debugging" }
    )
  end

  -- you can use <leader>lf for formatting
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.format {async = true}' ]]
end
-- URL handling
-- source: https://sbulav.github.io/vim/neovim-opening-urls/
if vim.fn.has "mac" == 1 then
  keymap(
    "",
    "gx",
    '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>',
    {}
  )
elseif vim.fn.has "unix" == 1 then
  keymap(
    "",
    "gx",
    '<Cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>',
    {}
  )
else
  keymap[""].gx = {
    '<Cmd>lua print("Error: gx is not supported on this OS!")<CR>',
  }
end
-- Java

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local vopts = {
  mode = "v", -- VISUAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
  J = {
    name = "Java",
    o = {
      "<Cmd>lua require'jdtls'.organize_imports()<CR>",
      "Organize Imports",
    },
    v = {
      "<Cmd>lua require('jdtls').extract_variable()<CR>",
      "Extract Variable",
    },
    c = {
      "<Cmd>lua require('jdtls').extract_constant()<CR>",
      "Extract Constant",
    },
    t = {
      "<Cmd>lua require'jdtls'.test_nearest_method()<CR>",
      "Test Method",
    },
    T = { "<Cmd>lua require'jdtls'.test_class()<CR>", "Test Class" },
    u = { "<Cmd>JdtUpdateConfig<CR>", "Update Config" },
  },
}

local vmappings = {
  J = {
    name = "Java",
    v = {
      "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
      "Extract Variable",
    },
    c = {
      "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
      "Extract Constant",
    },
    m = {
      "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
      "Extract Method",
    },
  },
}

which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

return M
