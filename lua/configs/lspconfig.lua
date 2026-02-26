local lspconfig = require "lspconfig"
local nvc = require "nvchad.configs.lspconfig"

local servers = { "html", "cssls","jdtls" }

local fvm_dart = vim.fn.expand("~/fvm/default/bin/dart")

lspconfig.dartls.setup {
  cmd = { fvm_dart, "language-server", "--protocol=lsp" },
  rootPatterns = { "pubspec.yaml", ".dart_tool" },
  filetypes = { "dart" },
}

vim.lsp.enable(servers)

