local options = {
  formatters_by_ft = {
    -- C - CPP
    c = { "clang_format" },
    h = { "clang_format" },
    cpp = { "clang_format" },
    -- Python
    python = { "black" },
    shell = { "shfmt" },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 5000,
    lsp_fallback = true,
  },
  -- log_level = vim.log.levels.ERROR,
}

require("conform").setup(options)
