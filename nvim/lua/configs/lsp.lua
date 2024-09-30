local configs = require "nvchad.configs.lspconfig"

local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require "lspconfig"

lspconfig.clangd.setup {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "/run/current-system/sw/bin/clangd" },
  filetypes = { "c", "cpp", "cc", "objc", "objcpp", "h" },
  root_dir = lspconfig.util.root_pattern(
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    ".git"
  ),
  auto_start = true,
  single_file_support = true,
}

lspconfig.bashls.setup {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = "sh",
  auto_start = true,
  single_file_support = true,
}

--python
lspconfig.pyright.setup {
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
}
