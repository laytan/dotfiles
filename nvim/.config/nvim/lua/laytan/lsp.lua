local util = require('lspconfig.util')

local higroup = vim.api.nvim_create_augroup('hilspiepie', {})

local function config(_config, on_attach)
  local dec_on_attach = function(client, bufnr)
    -- todo removable?
    -- If the LSP client supports highlighting, set it up.
    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd(
        { 'CursorHold', 'CursorHoldI' }, {
          group = higroup,
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        }
      )

      vim.api.nvim_create_autocmd(
        'CursorMoved', {
          group = higroup,
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        }
      )
    end

    if on_attach ~= nil then
      on_attach(client, bufnr)
    end
  end

  return vim.tbl_deep_extend(
    'keep', {
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      on_attach = dec_on_attach,
    }, _config or {}
  )
end

-- Makes Drupal modules have the base Drupal site as their root dir.
-- Makes cakephp plugins have the base cake app as their root dir.
local function php_root_dirs(fname)
  local is_drupal_module = util.root_pattern('modules')(fname) ~= nil
  local is_plugin = util.root_pattern('plugins')(fname) ~= nil
  local is_wordpress = util.root_pattern('wp-content')(fname) ~= nil
  local is_cake_plugin = is_plugin and not is_wordpress

  if is_wordpress then
    return util.root_pattern('wp-content')(fname)
  end

  if is_drupal_module then
    return util.root_pattern('web')(fname)
  end

  if is_cake_plugin then
    return util.root_pattern('plugins')(fname)
  end

  return util.root_pattern('composer.json')(fname) or
           util.root_pattern('.git')(fname)
end

require('fidget').setup({
  progress = {
    display = {
      render_limit = 100,
      done_ttl     = 5,
    },
  },
})

local builtin = require('telescope.builtin')
local themes = require('telescope.themes')
local dropdown_theme = themes.get_dropdown()

local util = require('lspconfig.util')

-- vim.lsp.set_log_level(vim.log.levels.INFO)

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
local format_on_save_enabled = false
vim.api.nvim_create_user_command(
  'FormatOnSaveToggle', function()
    -- require('tailwind-sorter').toggle_on_save()

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

-- configs.phpls = {
--   default_config = {
--     cmd = { 'phpls' },
--     filetypes = { 'php' },
--     root_dir = function(pattern)
--       local cwd = vim.loop.cwd()
--       local root = util.root_pattern('.git')(pattern)
--
--       return util.path.is_descendant(cwd, root) and cwd or root
--     end,
--   },
-- }
--
-- configs.tos = {
--   default_config = {
--     cmd = { '/Users/laytan/projects/tos/bin/release_safe' },
--     filetypes = { 'odin' },
--     root_dir = util.root_pattern('.git', 'ols.json'),
--   },
-- }
--
-- configs.composer = {
--   default_config = {
--     cmd = { 'composer-language-server', '--stdio' },
--     filetypes = { 'json' },
--     root_dir = function(pattern)
--       local cwd = vim.loop.cwd()
--       local root = util.root_pattern('composer.json')(pattern)
--
--       return util.path.is_descendant(cwd, root) and cwd or root
--     end,
--   },
-- }

-- lspconfig.denols.setup(
--   config(
--     { root_dir = util.root_pattern('deno.json', 'deno.jsonc') }
--   )
-- )

-- @deprecated
-- lspconfig.tsserver.setup(
--   config(
--     {
--       root_dir = util.root_pattern('package.json'),
--       single_file_support = false,
--
--       -- Turn off formatting, we have prettier and eslint for that.
--       on_init = function(client)
--         client.server_capabilities.documentFormattingProvider = false
--         client.server_capabilities.documentRangeFormattingProvider = false
--       end,
--     }
--   )
-- )

vim.lsp.config('*', config())

vim.lsp.config('tailwindcss', {
  root_markers = {'tailwind.config.js', 'tailwind.config.ts'},
})

vim.lsp.config('lua_ls', {
  settings = {
    workspace = {
      checkThirdParty = false,
    },
  },
})

vim.lsp.config('emmet_ls', {
  {
    autostart = false,
    filetypes = { 'html', 'twig', 'typescriptreact', 'php' },
  }
})

vim.lsp.config('phpactor', {
  root_dir = php_root_dirs,
})

vim.lsp.config('yamlls', {
  settings = { yaml = { keyOrdering = false } },
})

vim.lsp.enable({
  'tailwindcss',
  'vue_ls',
  'composer',
  'csharp_ls',
  'pyright',
  'lua_ls',
  'emmet_ls',
  'phpactor',
  'gopls',
  'terraformls',
  'yamlls',
  'ols',
  'clangd',
})

-- lspconfig.stylelint_lsp.setup(
--   config(
--     { filetypes = { 'css', 'scss', 'vue', 'html', 'blade', 'twig' } }
--   )
-- )

-- lspconfig.phpls.setup(
--   config(
--     {
--       cmd = {
--         'phpls',
--         '-extensions=.php,.module,.install,.theme,.sfc,.inc',
--       },
--       root_dir = php_root_dirs,
--     }
--   )
-- )

vim.lsp.inlay_hint.enable(true)

vim.keymap.set(
  'n', '<leader>d', function()
    builtin.lsp_definitions()
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
vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)

vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help)

vim.keymap.set(
  'n', '<C-f>', function()
    vim.lsp.buf.format({ async = true })
  end
)

vim.keymap.set('n', '<leader>hh', vim.lsp.buf.hover)
