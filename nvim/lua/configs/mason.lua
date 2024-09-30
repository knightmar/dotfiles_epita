return {
  auto_install = true,
  ensure_installed = {
    --format
    "shfmt",

    -- c / cpp
    "clangd",
    "clang-format",

    -- Python
    "pyright",
    "black",

    --bash
    "bash_language_server",
  },
}
