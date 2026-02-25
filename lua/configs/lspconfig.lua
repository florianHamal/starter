local lspconfig = require "lspconfig"
local nvc = require "nvchad.configs.lspconfig"

local servers = { "html", "cssls","jdtls" }

vim.lsp.enable(servers)

