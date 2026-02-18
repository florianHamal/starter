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
}
