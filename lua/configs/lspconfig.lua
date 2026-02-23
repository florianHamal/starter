local lspconfig = require "lspconfig"
local nvc = require "nvchad.configs.lspconfig"

local servers = { "html", "cssls","jdtls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvc.on_attach,
    on_init = nvc.on_init,
    capabilities = nvc.capabilities,
  }
end
