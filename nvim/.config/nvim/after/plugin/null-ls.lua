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

local local_composer = { prefer_local = 'vendor/bin' }
local fmt_no_code = { diagnostics_format = '[#{s}] #{m}' }
local diag_on_save = { method = null.methods.DIAGNOSTICS_ON_SAVE }

null.setup(
  {
    debug = true,
    root_dir = utils.root_pattern('.null-ls-root', 'Makefile'),
    on_attach = setup_format_on_save,
    diagnostics_format = '[#{s}] #{m} (#{c})',
    sources = {
      -- Diagnostics
      --
      -- General
      diagnostics.trail_space,
      -- PHP
      diagnostics.phpstan.with(local_composer).with(fmt_no_code),
      diagnostics.phpcs.with(local_composer).with(diag_on_save).with(
        { extra_args = { '--cache' } }
      ),
      diagnostics.phpmd.with(local_composer).with(diag_on_save).with(
        { extra_args = { 'phpmd.xml' } }
      ),
      -- Twig
      diagnostics.twigcs.with(local_composer).with(fmt_no_code).with(
        { extra_args = { '--twig-version', '2' } }
      ),
      -- GO
      diagnostics.golangci_lint,
      -- Lua
      diagnostics.selene,
      -- JS
      diagnostics.eslint_d.with({ extra_filetypes = { 'yaml' } }),
      diagnostics.tsc,
      -- Docker
      diagnostics.hadolint,

      -- Formatting
      --
      -- PHP
      formatting.phpcbf.with(local_composer),
      -- GO
      formatting.gofumpt,
      formatting.goimports_reviser.with(
        {
          args = {
            '-file-path',
            'FILENAME',
            '-output',
            'stdout',
            '-set-alias',
            '-rm-unused',
          },
        }
      ),
      formatting.golines,
      -- Python
      formatting.isort,
      -- Lua
      formatting.lua_format,
      -- JS
      formatting.eslint_d.with({ extra_filetypes = { 'yaml' } }),
      -- JSON
      formatting.fixjson,

      -- Code actions
      --
      -- JS
      actions.eslint_d,
    },
  }
)
