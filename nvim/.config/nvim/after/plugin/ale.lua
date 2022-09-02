vim.g.ale_echo_msg_format = '[%linter%] %s [%severity%]'
vim.g.ale_linters_explicit = 1
vim.g.ale_disable_lsp = 1
vim.g.ale_lint_on_text_changed = 0

vim.g.ale_linters = {
  php = { 'phpstan', 'phpcs' },
  go = { 'golangci-lint' },
  javascript = { 'eslint' },
  vue = { 'eslint' },
  typescript = { 'eslint' },
}

vim.g.ale_fixers = {
  php = { 'phpcbf' },
  vue = { 'eslint' },
  scss = { 'stylelint' },
  javascript = { 'eslint' },
  typescript = { 'eslint' },
  cs = {},
  python = { 'add_blank_lines_for_python_control_statements', 'isort' },
  lua = { 'lua-format' },
  go = { 'gofumpt', 'golines' },
}

vim.g.ale_pattern_options = {
  ['\\.html\\.twig$'] = { ale_fixers = { 'stylelint' } },
  ['\\.sfc$'] = { ale_fixers = { 'stylelint' } },
}

vim.g.ale_fix_on_save = 1
-- Can we set a default, only when none is provided by the current project?
-- vim.g.ale_php_phpcs_standard='PSR12'
vim.g.ale_go_golangci_lint_options = ''
vim.g.ale_go_golangci_lint_package = 1

