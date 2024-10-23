return {
  auto_install = true,
  ensure_installed = {
    "lua-language-server",
    "stylua",
    "css-lsp",
    "html-lsp",
    "shfmt",

    -- c / cpp
    "clangd",
    "clang-format",

    -- CSharp
    "csharpier",
    "csharp-language-server",
    -- rust
    "rust-analyzer",

    -- Python
    "pyright",
    "black",

    -- OCaml
    "ocaml-lsp",
    "ocamlformat",

    -- SQL
    "sqlls",
  },
}
