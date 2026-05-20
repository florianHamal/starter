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
         "javascript",
         "typescript",
         "tsx",
         "jsx",
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
      distance_stop_animating = 1.0,
      time_interval = 24,
      smear_vertically = false,
      smear_between_neighbor_lines = false,
      scroll_buffer_space = false,
    },
    config = function(_, opts)
      local events = require("smear_cursor.events")
      local smear = require("smear_cursor")

      local mode_colors = {
        n = "#7aa2f7",
        i = "#9ece6a",
        v = "#e0af68",
        V = "#e0af68",
        ["\22"] = "#e0af68",
        c = "#bb9af7",
        R = "#f7768e",
        t = "#73daca",
      }

      local set_mode_cursor_highlights = function()
        vim.api.nvim_set_hl(0, "CursorNormal", { fg = "#1a1b26", bg = mode_colors.n })
        vim.api.nvim_set_hl(0, "CursorInsert", { fg = "#1a1b26", bg = mode_colors.i })
        vim.api.nvim_set_hl(0, "CursorVisual", { fg = "#1a1b26", bg = mode_colors.v })
        vim.api.nvim_set_hl(0, "CursorCommand", { fg = "#1a1b26", bg = mode_colors.c })
        vim.api.nvim_set_hl(0, "CursorReplace", { fg = "#1a1b26", bg = mode_colors.R })
        vim.api.nvim_set_hl(0, "CursorTerminal", { fg = "#1a1b26", bg = mode_colors.t })

        vim.opt.guicursor = table.concat({
          "n:block-CursorNormal",
          "v:block-CursorVisual",
          "c:block-CursorCommand",
          "i-ci-ve:ver25-CursorInsert",
          "r-cr:hor20-CursorReplace",
          "o:hor50-CursorVisual",
          "a:blinkon0",
        }, ",")
      end

      local apply_mode_cursor_color = function()
        local mode = vim.api.nvim_get_mode().mode
        local color = mode_colors[mode:sub(1, 1)] or mode_colors.n

        vim.api.nvim_set_hl(0, "Cursor", { fg = "#1a1b26", bg = color })
        smear.cursor_color = color
      end

      local remove_win_scrolled = function()
        local ok, autocmds = pcall(vim.api.nvim_get_autocmds, {
          group = "SmearCursor",
          event = "WinScrolled",
        })
        if not ok then return end

        for _, autocmd in ipairs(autocmds) do
          pcall(vim.api.nvim_del_autocmd, autocmd.id)
        end
      end

      local original_listen = events.listen
      events.listen = function(...)
        original_listen(...)
        remove_win_scrolled()
      end

      smear.setup(opts)
      local mode_group = vim.api.nvim_create_augroup("SmearCursorModeColor", { clear = true })
      vim.api.nvim_create_autocmd({ "ModeChanged", "VimEnter", "ColorScheme" }, {
        group = mode_group,
        callback = function()
          set_mode_cursor_highlights()
          apply_mode_cursor_color()
        end,
      })
      set_mode_cursor_highlights()
      apply_mode_cursor_color()

      vim.schedule(remove_win_scrolled)
    end,
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
