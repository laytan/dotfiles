local null = require('null-ls')
local utils = require('null-ls.utils')
local diagnostics = null.builtins.diagnostics
local formatting = null.builtins.formatting
local actions = null.builtins.code_actions

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
local setup_format_on_save = function(client, bufnr)
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd(
      'BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
    }
    )
  end
end

null.setup(
  {
    root_dir = utils.root_pattern('.null-ls-root', 'Makefile'),
    on_attach = setup_format_on_save,
    sources = {
      -- Diagnostics
      --
      -- General
      diagnostics.trail_space,
      -- PHP
      diagnostics.phpstan,
      diagnostics.phpcs,
      diagnostics.phpmd,
      -- Twig
      diagnostics.twigcs,
      -- GO
      diagnostics.golangci_lint,
      -- Lua
      diagnostics.selene,
      -- JS
      diagnostics.eslint_d.with({ extra_filetypes = { 'yml' } }),
      diagnostics.tsc,
      -- Docker
      diagnostics.hadolint,

      -- Formatting
      --
      -- PHP
      formatting.phpcbf,
      -- GO
      formatting.gofumpt,
      formatting.goimports_reviser,
      formatting.golines,
      -- Python
      formatting.isort,
      -- Lua
      formatting.lua_format,
      -- JS
      formatting.eslint_d,
      -- JSON
      formatting.fixjson,

      -- Code actions
      --
      -- JS
      actions.eslint_d,
    },
  }
)
