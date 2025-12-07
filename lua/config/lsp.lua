local servers = {
  "gopls",
  "lua_ls",
  "pyright",
  "pylsp",
  "rust-analyzer", -- Rust language server
  "tailwindcss",   -- Tailwind CSS language server
  "html-ls",       -- HTML language server
  "css-ls",        -- CSS language server
  "vue-ls",        -- Vue language server
  "nil",
}

local function get_capabilities()
    -- Check if blink.cmp is available
    local has_blink, blink = pcall(require, "blink.cmp")

    if has_blink and blink.get_lsp_capabilities then
        -- Merge default capabilities with blink.cmp capabilities
        return vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            blink.get_lsp_capabilities(),
            {
                -- Additional capabilities can be added here
                workspace = {
                    fileOperations = {
                        didRename = true,
                        willRename = true,
                    },
                },
            }
        )
    else
        -- Fallback to default capabilities if blink.cmp is not available
        return vim.lsp.protocol.make_client_capabilities()
    end
end

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

    map("n", "]d", function() vim.diagnostic.jump({ count = 1,float= true}) end, { desc = "Next Diagnostic" })
    map("n", "[d", function() vim.diagnostic.jump({ count = -1,float= true}) end, { desc = "Prev Diagnostic" })
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

-- ============================================================================
-- LSP Server Setup
-- ============================================================================

local capabilities = get_capabilities()

for _, server_name in ipairs(servers) do
    -- Load server-specific config from lsp/<server-name>.lua
    local config_path = vim.fn.stdpath("config") .. "/lsp/" .. server_name .. ".lua"

    if vim.fn.filereadable(config_path) == 1 then
        -- Load the config file
        local ok, server_config = pcall(dofile, config_path)

        if ok and type(server_config) == "table" then
            -- Merge capabilities with server config
            server_config.capabilities = vim.tbl_deep_extend(
                "force",
                capabilities,
                server_config.capabilities or {}
            )

            -- Enable the LSP with the loaded config
            vim.lsp.enable(server_name, server_config)
        else
            -- If config load failed, enable with default config
            vim.notify(
                string.format("Failed to load config for %s, using defaults", server_name),
                vim.log.levels.WARN
            )
            vim.lsp.enable(server_name, { capabilities = capabilities })
        end
    else
        -- No config file, use default config
        vim.lsp.enable(server_name, { capabilities = capabilities })
    end
end

-- ============================================================================
-- Utility Commands
-- ============================================================================

-- LspRestart: Restart LSP clients for current buffer
vim.api.nvim_create_user_command("LspRestart", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then
        vim.notify("No LSP clients attached to restart", vim.log.levels.WARN)
        return
    end

    for _, client in ipairs(clients) do
        vim.notify("Restarting " .. client.name, vim.log.levels.INFO)
        vim.lsp.stop_client(client.id)
    end

    vim.defer_fn(function()
        vim.cmd("edit")
    end, 100)
end, { desc = "Restart LSP clients for current buffer" })

-- LspStatus: Show brief LSP status
vim.api.nvim_create_user_command("LspStatus", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then
        print("󰅚 No LSP clients attached")
        return
    end

    print("󰒋 LSP Status for buffer " .. bufnr .. ":")
    print("─────────────────────────────────")

    for i, client in ipairs(clients) do
        print(string.format("󰌘 Client %d: %s (ID: %d)", i, client.name, client.id))
        print("  Root: " .. (client.config.root_dir or "N/A"))
        print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

        local caps = client.server_capabilities
        local features = {}
        if caps.completionProvider then table.insert(features, "completion") end
        if caps.hoverProvider then table.insert(features, "hover") end
        if caps.definitionProvider then table.insert(features, "definition") end
        if caps.referencesProvider then table.insert(features, "references") end
        if caps.renameProvider then table.insert(features, "rename") end
        if caps.codeActionProvider then table.insert(features, "code_action") end
        if caps.documentFormattingProvider then table.insert(features, "formatting") end

        print("  Features: " .. table.concat(features, ", "))
        print("")
    end
end, { desc = "Show brief LSP status" })

-- LspCapabilities: Show all capabilities for attached LSP clients
vim.api.nvim_create_user_command("LspCapabilities", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then
        print("No LSP clients attached")
        return
    end

    for _, client in ipairs(clients) do
        print("Capabilities for " .. client.name .. ":")
        local caps = client.server_capabilities

          local capability_list = {
              { "Completion",                caps.completionProvider },
              { "Hover",                     caps.hoverProvider },
              { "Signature Help",            caps.signatureHelpProvider },
              { "Go to Definition",          caps.definitionProvider },
              { "Go to Declaration",         caps.declarationProvider },
              { "Go to Implementation",      caps.implementationProvider },
              { "Go to Type Definition",     caps.typeDefinitionProvider },
              { "Find References",           caps.referencesProvider },
              { "Document Highlight",        caps.documentHighlightProvider },
              { "Document Symbol",           caps.documentSymbolProvider },
              { "Workspace Symbol",          caps.workspaceSymbolProvider },
              { "Code Action",               caps.codeActionProvider },
              { "Code Lens",                 caps.codeLensProvider },
              { "Document Formatting",       caps.documentFormattingProvider },
              { "Document Range Formatting", caps.documentRangeFormattingProvider },
              { "Rename",                    caps.renameProvider },
              { "Folding Range",             caps.foldingRangeProvider },
              { "Selection Range",           caps.selectionRangeProvider },
              { "Inlay Hint",                caps.inlayHintProvider },
          }

          for _, cap in ipairs(capability_list) do
              local status = cap[2] and "✓" or "✗"
              print(string.format("  %s %s", status, cap[1]))
          end
          print("")
    end
end, { desc = "Show all LSP capabilities" })

-- LspDiagnostics: Show diagnostic counts
vim.api.nvim_create_user_command("LspDiagnostics", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local diagnostics = vim.diagnostic.get(bufnr)

    local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

    for _, diagnostic in ipairs(diagnostics) do
        local severity = vim.diagnostic.severity[diagnostic.severity]
        counts[severity] = counts[severity] + 1
    end

    print("󰒡 Diagnostics for current buffer:")
    print("  Errors: " .. counts.ERROR)
    print("  Warnings: " .. counts.WARN)
    print("  Info: " .. counts.INFO)
    print("  Hints: " .. counts.HINT)
    print("  Total: " .. #diagnostics)
end, { desc = "Show diagnostic counts for current buffer" })

-- LspInfo: Comprehensive LSP information
vim.api.nvim_create_user_command("LspInfo", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    print("═══════════════════════════════════")
    print("           LSP INFORMATION          ")
    print("═══════════════════════════════════")
    print("")

    print("󰈙 Language client log: " .. vim.lsp.get_log_path())
    print("󰈔 Detected filetype: " .. vim.bo.filetype)
    print("󰈮 Buffer: " .. bufnr)
    print("󰈔 Root directory: " .. (vim.fn.getcwd() or "N/A"))
    print("")

    if #clients == 0 then
        print("󰅚 No LSP clients attached to buffer " .. bufnr)
        print("")
        print("Possible reasons:")
        print("  • No language server installed for " .. vim.bo.filetype)
        print("  • Language server not configured")
        print("  • Not in a project root directory")
        print("  • File type not recognized")
        return
    end

    print("󰒋 LSP clients attached to buffer " .. bufnr .. ":")
    print("─────────────────────────────────")

    for i, client in ipairs(clients) do
        print(string.format("󰌘 Client %d: %s", i, client.name))
        print("  ID: " .. client.id)
        print("  Root dir: " .. (client.config.root_dir or "Not set"))
        print("  Command: " .. table.concat(client.config.cmd or {}, " "))
        print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

        if client.is_stopped() then
            print("  Status: 󰅚 Stopped")
        else
            print("  Status: 󰄬 Running")
        end

        if client.workspace_folders and #client.workspace_folders > 0 then
            print("  Workspace folders:")
            for _, folder in ipairs(client.workspace_folders) do
                print("    • " .. folder.name)
            end
        end

        local attached_buffers = {}
        for buf, _ in pairs(client.attached_buffers or {}) do
            table.insert(attached_buffers, buf)
        end
        print("  Attached buffers: " .. #attached_buffers)

        local caps = client.server_capabilities
        local key_features = {}
        if caps.completionProvider then table.insert(key_features, "completion") end
        if caps.hoverProvider then table.insert(key_features, "hover") end
        if caps.definitionProvider then table.insert(key_features, "definition") end
        if caps.documentFormattingProvider then table.insert(key_features, "formatting") end
        if caps.codeActionProvider then table.insert(key_features, "code_action") end

        if #key_features > 0 then
            print("  Key features: " .. table.concat(key_features, ", "))
        end

        print("")
    end

    local diagnostics = vim.diagnostic.get(bufnr)
    if #diagnostics > 0 then
        print("󰒡 Diagnostics Summary:")
        local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

        for _, diagnostic in ipairs(diagnostics) do
            local severity = vim.diagnostic.severity[diagnostic.severity]
            counts[severity] = counts[severity] + 1
        end

        print("  󰅚 Errors: " .. counts.ERROR)
        print("  󰀪 Warnings: " .. counts.WARN)
        print("  󰋽 Info: " .. counts.INFO)
        print("  󰌶 Hints: " .. counts.HINT)
        print("  Total: " .. #diagnostics)
    else
        print("󰄬 No diagnostics")
    end

    print("")
    print("Use :LspLog to view detailed logs")
    print("Use :LspCapabilities for full capability list")
end, { desc = "Show comprehensive LSP information" })
