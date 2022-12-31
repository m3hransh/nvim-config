local handler = require("core.lsp.handler")


local servers = {
  gopls = {},
  html = {},
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
      },
    },
  },
  pyright = {
    analysis = {
      typeCheckingMode = "off",
    },
  },
  -- pylsp = {}, -- Integration with rope for refactoring - https://github.com/python-rope/pylsp-rope
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = {
          command = "clippy",
          extraArgs = { "--no-deps" },
        },
      },
    },
  },
  sumneko_lua = {
    settings = {
    },
  },
  tsserver = { disable_formatting = true },
  vimls = {},
  tailwindcss = {},
  yamlls = {
    schemastore = {
      enable = true,
    },
    settings = {
      yaml = {
        hover = true,
        completion = true,
        validate = true,
        schemas = require("schemastore").json.schemas(),
      },
    },
  },
  jdtls = {},
  dockerls = {},
  graphql = {},
  bashls = {},
  omnisharp = {},
  kotlin_language_server = {},
  emmet_ls = {},
  marksman = {},
  angularls = {},
}


local options = {
  on_attach = handler.on_attach,
  capabilities = handler.capabilities,
}
handler.setup()

require('core.lsp.installer').setup(servers, options)
