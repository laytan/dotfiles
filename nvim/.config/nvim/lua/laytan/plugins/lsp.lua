-- LSP.
return {
  'neovim/nvim-lspconfig', -- Standard configuration for most LSPs.
  dependencies = {
    'kosayoda/nvim-lightbulb', -- Shows a lightbulb on the left if there are code actions for that line.
    { 'j-hui/fidget.nvim', config = { window = { blend = 0 } } }, -- Shows progress and status of LSPs and their actions.
    'nvim-telescope/telescope.nvim', -- Used as picker if there are multiple options.
    'folke/neodev.nvim',
  },
  event = 'BufReadPre',
  config = function()
    local lspconfig = require('lspconfig')
    local builtin = require('telescope.builtin')
    local themes = require('telescope.themes')
    local dropdown_theme = themes.get_dropdown()

    local configs = require('lspconfig.configs')
    local util = require('lspconfig.util')
    local config, php_root_dirs = require('laytan.lsp').config,
                                  require('laytan.lsp').php_root_dirs

    require('nvim-lightbulb').setup(
      {
        virtual_text = { enabled = true },
        status_text = { enabled = true },
        autocmd = { enabled = true },
      }
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

    lspconfig.denols.setup(
      config(
        { root_dir = util.root_pattern('deno.json', 'deno.jsonc') }
      )
    )

    lspconfig.tsserver.setup(
      config(
        {
          root_dir = util.root_pattern('package.json'),
          single_file_support = false,
        }
      )
    )

    lspconfig.tailwindcss.setup(config())

    lspconfig.volar.setup(config())

    lspconfig.composer.setup(config())

    lspconfig.csharp_ls.setup(config())

    lspconfig.pyright.setup(config())

    -- lspconfig.stylelint_lsp.setup(
    --   config(
    --     { filetypes = { 'css', 'scss', 'vue', 'html', 'blade', 'twig' } }
    --   )
    -- )

    lspconfig.sumneko_lua.setup(
      config(
        {
          -- Turn off formatting for this LSP, we are using lua_format from null-ls.
          on_init = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        }
      )
    )

    lspconfig.emmet_ls.setup(
      config(
        { filetypes = { 'html', 'twig', 'typescriptreact', 'php' } }
      )
    )

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
            '-v',
          },
          root_dir = php_root_dirs,
        }
      )
    )

    lspconfig.gopls.setup(config({}))

    lspconfig.terraformls.setup({})

    lspconfig.yamlls.setup({})

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
  end,
}
