 if vim.loop.os_uname().sysname == "Windows_NT" then
  vim.env.HOME = vim.env.USERPROFILE
end
return {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
  },

  {
    "akinsho/flutter-tools.nvim",
    lazy = false, -- Important: flutter-tools needs to start to take over dartls
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local nvc = require "nvchad.configs.lspconfig"

      require("flutter-tools").setup {
        fvm = true,
        lsp = {
          on_attach = nvc.on_attach,
          capabilities = nvc.capabilities,
          settings = {
            showTodos = true,
            completeFunctionCalls = true, -- Auto-tabs into arguments
            enableSnippets = true,        -- Required for "child:" suggestions
          },
        },
      }
    end,
  },
{
  "nickjvandyke/opencode.nvim",
  version = "*", -- Latest stable release
  dependencies = {
      -- `snacks.nvim` integration is recommended, but optional
      ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {}, -- Enhances `ask()`
        picker = { -- Enhances `select()`
          actions = {
            opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
        terminal = {}, -- Enables the `snacks` provider
      },
    },
  },
}
