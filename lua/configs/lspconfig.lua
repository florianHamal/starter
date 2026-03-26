local lspconfig = require "lspconfig"
local nvc = require "nvchad.configs.lspconfig"

local servers = { "html", "cssls", "kotlin_language_server" }

local fvm_dart = vim.fn.expand("~/fvm/default/bin/dart")

lspconfig.dartls.setup {
  cmd = { fvm_dart, "language-server", "--protocol=lsp" },
  rootPatterns = { "pubspec.yaml", ".dart_tool" },
  filetypes = { "dart" },
}

for _, server in ipairs(servers) do
  lspconfig[server].setup {
    on_attach = nvc.on_attach,
    capabilities = nvc.capabilities,
  }
end

local jdtls_path = vim.fn.exepath("jdtls")
if jdtls_path == "" then
  jdtls_path = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
end

local function get_jdtls_config()
  local project_root = vim.fn.getcwd()
  
  local java_home = os.getenv("JAVA_HOME")
  
  if not java_home or not vim.fn.isdirectory(java_home) then
    local jdk21 = "/usr/lib/jvm/java-21-openjdk-amd64"
    if vim.fn.isdirectory(jdk21) then
      java_home = jdk21
    else
      java_home = "/usr/lib/jvm/default-java"
    end
  end
  
  local java_executable = java_home .. "/bin/java"
  
  local cache_dir = vim.fn.stdpath("cache") .. "/jdtls"
  local workspace_dir = cache_dir .. "/workspace/" .. vim.fn.fnamemodify(project_root, ":p:h:t")
  
  vim.fn.mkdir(workspace_dir, "p")
  vim.fn.mkdir(cache_dir .. "/config", "p")
  
  local cmd = {
    jdtls_path,
    "--java-executable",
    java_executable,
    "-configuration",
    vim.fn.stdpath("data") .. "/mason/packages/jdtls/config_linux",
    "-data",
    workspace_dir,
  }
  
  local config = {
    cmd = cmd,
    root_dir = lspconfig.util.root_pattern("pom.xml", "build.gradle", ".git"),
    on_attach = nvc.on_attach,
    capabilities = nvc.capabilities,
    settings = {
      java = {
        eclipse = {
          downloadSources = true,
        },
        maven = {
          downloadSources = true,
        },
        compilations = {
          release = "1.8",
        },
      },
    },
  }
  
  return config
end

lspconfig.jdtls.setup(get_jdtls_config())
