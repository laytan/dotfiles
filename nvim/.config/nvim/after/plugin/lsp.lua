local lspconfig = require('lspconfig')
local builtin = require('telescope.builtin')
local themes = require('telescope.themes')
local dropdown_theme = themes.get_dropdown()

local configs = require('lspconfig.configs')
local util = require('lspconfig.util')
local config, php_root_dirs = require('laytan.lsp').config,
                              require('laytan.lsp').php_root_dirs
local lsp_time = require('laytan.lsp_time')

require('nvim-lightbulb').setup(
  { sign = { enabled = true, priority = 100 }, autocmd = { enabled = true } }
)

configs.elephp = {
  default_config = {
    cmd = { 'elephp', '--stdio' },
    filetypes = { 'php' },
    root_dir = function(pattern)
      local cwd = vim.loop.cwd()
      local root = util.root_pattern('.git')(pattern)

      return util.path.is_descendant(cwd, root) and cwd or root
    end,
  },
}

-- TODO: add to lspconfig repo.
configs.composer = {
  default_config = {
    cmd = { 'composer-language-server', '--stdio' },
    filetypes = { 'json' },
    root_dir = function(pattern)
      local cwd = vim.loop.cwd()
      local root = util.root_pattern('composer.json')(pattern)

      return util.path.is_descendant(cwd, root) and cwd or root
    end,
  },
}

lspconfig.tsserver.setup(config())

lspconfig.tailwindcss.setup(
  config(
    {
      root_dir = require('lspconfig.util').root_pattern(
        'tailwind.config.js', 'tailwind.config.ts'
      ),
      filetypes = { 'blade', 'html', 'twig', 'css', 'scss', 'vue', 'svelte' },
    }
  )
)

lspconfig.volar.setup(config())

lspconfig.composer.setup(config())

lspconfig.csharp_ls.setup(config())

lspconfig.pyright.setup(config())

lspconfig.stylelint_lsp.setup(
  config(
    { filetypes = { 'css', 'scss', 'vue', 'html', 'blade', 'twig' } }
  )
)

lspconfig.sumneko_lua.setup(
  config(
    {
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim' },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file('', true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = { enable = false },
        },
      },
    }
  )
)

lspconfig.emmet_ls.setup(config({ filetypes = { 'html', 'twig' } }))

-- lspconfig.phpactor.setup(
--   config(
--     {
--       root_dir = function(pattern)
--         local cwd = vim.loop.cwd()
--         local root = util.root_pattern('.git')(pattern)
--
--         return util.path.is_descendant(cwd, root) and cwd or root
--       end,
--       handlers = lsp_time.get_handlers(
--         { ['textDocument/hover'] = true, ['textDocument/definition'] = true }
--       ),
--     }
--   )
-- )

lspconfig.elephp.setup(
  config(
    {
      cmd = {
        'elephp',
        '--stdio',
        '-e php',
        '-e module',
        '-e install',
        '-e theme',
        '-e sfc',
        '-e inc',
      },
      root_dir = php_root_dirs,
      handlers = lsp_time.get_handlers(
        { ['textDocument/hover'] = true, ['textDocument/definition'] = true }
      ),
    }
  )
)
vim.lsp.set_log_level(vim.log.levels.INFO)

lspconfig.gopls.setup(config({}))

-- Format the given patterns using the LSP when saving.
vim.api.nvim_create_autocmd(
  'BufWritePre', { pattern = { '*.cs' }, callback = vim.lsp.buf.formatting }
)

vim.keymap.set(
  'n', '<leader>d', function()
    lsp_time.signal_start('textDocument/definition')

    -- TODO: can we still use telescope? (lsp_time)
    vim.lsp.buf.definition()
  end
)
vim.keymap.set(
  'n', '<leader>i', function()
    builtin.lsp_implementation()
  end
)
vim.keymap.set(
  'n', '<leader>w', function()
    builtin.lsp_references(dropdown_theme)
  end
)
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
vim.keymap.set(
  'n', '<leader>hh', function()
    lsp_time.signal_start('textDocument/hover')
    vim.lsp.buf.hover()
  end
)
vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
