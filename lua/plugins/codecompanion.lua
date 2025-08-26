return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
  keys = {
    {
      "<leader>ca",
      "<cmd>CodeCompanionActions<CR>",
      desc = "Open the action palette",
      mode = { "n", "v" },
    },
    {
      "<leader>co",
      "<cmd>CodeCompanionChat Toggle<CR>",
      desc = "Toggle a chat buffer",
      mode = { "n", "v" },
    },
    {
      "<leader>cc",
      "<cmd>CodeCompanionChat Add<CR>",
      desc = "Add code to a chat buffer",
      mode = { "v" },
    },
  },
  opts = {
    ---@module "codecompanion"
    ---@type CodeCompanion.Config
    strategies = {
      chat = {
        adapter = {
          name = "copilot",
          model = "gpt-4.1",
        },
        roles = {
          user = "Mehran",
        },
        keymaps = {
          send = {
            modes = {
              i = { "<C-CR>", "<C-s>" },
            },
          },
          completion = {
            modes = {
              i = "<C-x>",
            },
          },
        },
        slash_commands = {
          ["buffer"] = {
            keymaps = {
              modes = {
                i = "<C-b>",
              },
            },
          },
          ["fetch"] = {
            keymaps = {
              modes = {
                i = "<C-f>",
              },
            },
          },
          ["help"] = {
            opts = {
              max_lines = 1000,
            },
          },
          ["image"] = {
            keymaps = {
              modes = {
                i = "<C-i>",
              },
            },
            opts = {
              dirs = { "~/Documents/Screenshots" },
            },
          },
        },
      },
      inline = {
        adapter = {
          name = "copilot",
          model = "gpt-4.1",
        },
      },
    }
  }
}
