local null = require('null-ls')
local utils = require('null-ls.utils')
local diagnostics = null.builtins.diagnostics
local formatting = null.builtins.formatting
local actions = null.builtins.code_actions

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
local format_on_save_enabled = false
vim.api.nvim_create_user_command(
  'FormatOnSaveToggle', function()
    vim.api.nvim_clear_autocmds({ group = augroup })
    if format_on_save_enabled then
      format_on_save_enabled = false
      return
    end

    format_on_save_enabled = true
    vim.api.nvim_create_autocmd(
      'BufWritePre', {
      group = augroup,
      callback = function()
        vim.lsp.buf.format()
      end,
    }
    )
  end, {}
)

local local_composer = { prefer_local = 'vendor/bin' }
local fmt_no_code = { diagnostics_format = '[#{s}] #{m}' }
local diag_on_save = { method = null.methods.DIAGNOSTICS_ON_SAVE }
local require_phpcs_config = {
  condition = function(u)
    return u.root_has_file('phpcs.xml')
  end,
}

null.setup(
  {
    debug = true,
    root_dir = utils.root_pattern('.null-ls-root', 'Makefile'),
    diagnostics_format = '[#{s}] #{m} (#{c})',
    default_timeout = 30000,
    sources = {
      -- Diagnostics
      --
      -- General
      diagnostics.trail_space.with(fmt_no_code),
      -- PHP
      diagnostics.phpstan.with(local_composer).with(fmt_no_code).with(
        {
          condition = function(u)
            return u.root_has_file('phpstan.neon')
          end,
        }
      ),

      diagnostics.phpcs.with(local_composer).with(diag_on_save).with(
        { extra_args = { '--cache' } }
      ).with(require_phpcs_config),

      diagnostics.phpmd.with(local_composer).with(diag_on_save).with(
        { extra_args = { 'phpmd.xml' } }
      ).with(
        {
          condition = function(u)
            return u.root_has_file('phpmd.xml')
          end,
        }
      ),
      -- Twig
      diagnostics.twigcs.with(local_composer).with(fmt_no_code).with(
        { extra_args = { '--twig-version', '2' } }
      ),
      -- GO
      diagnostics.golangci_lint.with(fmt_no_code),
      -- Lua
      diagnostics.selene,
      -- JS
      diagnostics.eslint_d.with(fmt_no_code),
      diagnostics.tsc,
      -- Docker
      diagnostics.hadolint,

      -- Formatting
      --
      -- PHP
      formatting.phpcbf.with(local_composer).with(require_phpcs_config).with(
        { timeout = 30000 }
      ),
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
      formatting.eslint_d,
      -- JSON
      formatting.fixjson,
      -- Style
      formatting.stylelint,

      -- Code actions
      --
      -- JS
      actions.eslint_d,
    },
  }
)
