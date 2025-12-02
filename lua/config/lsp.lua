vim.lsp.enable({
  "gopls",
  "lua_ls",
  "pyright",
  "pylsp",
  "rust-analyzer", -- Rust language server
  "tailwindcss",   -- Tailwind CSS language server
  "html-ls",       -- HTML language server
  "css-ls",        -- CSS language server
  "vue-ls",        -- Vue language server
})

local function setup_keymaps(bufnr, client)

    local map = function(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, lhs, rhs, opts)
    end
    -- Basic LSP Mappings
    map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
    map("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
    map("n", "gr", vim.lsp.buf.references, { desc = "References" })
    map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
    map("n", "gI", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
    map("n", "gt", vim.lsp.buf.type_definition, { desc = "Goto Type Definition" })
    map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
    map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
    map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action" })
    map("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format" })

    map("n", "]e", function() vim.diagnostic.jump({ count = 1,float= true, severity=vim.diagnostic.severity.ERROR}) end, { desc = "Prev Error" })
    map("n", "[e", function() vim.diagnostic.jump({ count = -1,float= true, severity=vim.diagnostic.severity.ERROR}) end, { desc = "Prev Error" })
    -- Telescope Integration (if available)
    if pcall(require, "telescope") then
      local builtin = require("telescope.builtin")
      map("n", "gd", builtin.lsp_definitions, { desc = "Goto Definition" })
      map("n", "gr", builtin.lsp_references, { desc = "References" })
      map("n", "gI", builtin.lsp_implementations, { desc = "Goto Implementation" })
      map("n", "gt", builtin.lsp_type_definitions, { desc = "Goto Type Definition" })
      map("n", "<leader>ls", builtin.lsp_document_symbols, { desc = "Document Symbols" })
      map("n", "<leader>lS", builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace Symbols" })
    end
    -- Navbuddy
    if client.server_capabilities.documentSymbolProvider then
       map("n", "<leader>ln", "<cmd>Navbuddy<cr>", { desc = "Navbuddy" })
    end
    -- IncRename
    if client.server_capabilities.renameProvider then
       map("n", "<leader>lr", function() return ":IncRename " .. vim.fn.expand("<cword>") end, { expr = true, desc = "Rename" })
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local bufnr = ev.buf
    setup_keymaps(bufnr, client)
  end,
})

vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})
