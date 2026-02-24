local lspconfig = require "lspconfig"
local nvc = require "nvchad.configs.lspconfig"

local servers = { "html", "cssls","jdtls", "dartls" }

vim.lsp.enable(servers)

