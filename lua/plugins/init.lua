 if vim.loop.os_uname().sysname == "Windows_NT" then
  vim.env.HOME = vim.env.USERPROFILE
end
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "regex",
        "bash",
        "kotlin",
        "markdown",
        "markdown_inline",
      },
    },
  },

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
    ft = { "dart" }, -- Only load for Dart files; flutter-tools registers the LSP on first dart buffer
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local nvc = require "nvchad.configs.lspconfig"

      require("flutter-tools").setup {
        fvm = true,
        lsp = {
          on_attach = nvc.on_attach,
          capabilities = nvc.capabilities,
          -- Prevent the LSP from being killed too eagerly when it is slow to respond
          flags = {
            debounce_text_changes = 150,
            allow_incremental_sync = true,
          },
          settings = {
            showTodos = true,
            completeFunctionCalls = true, -- Auto-tabs into arguments
            enableSnippets = true,        -- Required for "child:" suggestions
            analysisExcludedFolders = {
              vim.fn.expand "$HOME/.pub-cache",
              vim.fn.expand "$HOME/fvm",
            },
          },
        },
      }

      local flutter_lsp_group = vim.api.nvim_create_augroup("FlutterLspReattach", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
        group = flutter_lsp_group,
        pattern = "*.dart",
        callback = function(args)
          if #vim.lsp.get_clients { bufnr = args.buf, name = "dartls" } == 0 then
            require("flutter-tools.lsp").attach()
          end
        end,
      })
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

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = false,
        },
        signature = {
          enabled = false,
        },
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },

  {
    "sphamba/smear-cursor.nvim",
    lazy = false,
    opts = {
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.5,
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    cmd = { "RenderMarkdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = {},
  },
}
