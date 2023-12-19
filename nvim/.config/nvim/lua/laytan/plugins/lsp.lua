-- LSP.
return {
  'neovim/nvim-lspconfig', -- Standard configuration for most LSPs.
  dependencies = {
    {
      'j-hui/fidget.nvim', -- Shows progress and status of LSPs and their actions.
      opts = {
        progress = {
          display = {
            render_limit = 100,
            done_ttl     = 5,
          },
        },
      },
    },
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

    -- vim.lsp.set_log_level(vim.log.levels.DEBUG)

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    local format_on_save_enabled = false
    vim.api.nvim_create_user_command(
      'FormatOnSaveToggle', function()
        require('tailwind-sorter').toggle_on_save()

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

    -- TODO: add to lspconfig repo.
    configs.phpls = {
      default_config = {
        cmd = { 'phpls' },
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

          -- Turn off formatting, we have prettier and eslint for that.
          on_init = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        }
      )
    )

    lspconfig.tailwindcss.setup(
      config(
        {
          root_dir = util.root_pattern(
            'tailwind.config.js', 'tailwind.config.ts'
          ),
        }
      )
    )

    lspconfig.volar.setup(config())

    lspconfig.composer.setup(config())

    lspconfig.csharp_ls.setup(config())

    lspconfig.pyright.setup(config())

    -- lspconfig.stylelint_lsp.setup(
    --   config(
    --     { filetypes = { 'css', 'scss', 'vue', 'html', 'blade', 'twig' } }
    --   )
    -- )

    lspconfig.lua_ls.setup(
      config(
        {
          -- Turn off formatting for this LSP, we are using lua_format from null-ls.
          on_init = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
          settings = {
            workspace = {
              checkThirdParty = false,
            },
          },
        }
      )
    )

    lspconfig.emmet_ls.setup(
      config(
        {
          autostart = false,
          filetypes = { 'html', 'twig', 'typescriptreact', 'php' },
        }
      )
    )

    lspconfig.ocamllsp.setup(config())

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

    lspconfig.phpls.setup(
      config(
        {
          cmd = {
            'phpls',
            '-extensions=.php,.module,.install,.theme,.sfc,.inc',
          },
          root_dir = php_root_dirs,
        }
      )
    )

    lspconfig.gopls.setup(config({}))

    lspconfig.terraformls.setup(config({}))

    lspconfig.yamlls.setup(
      config(
        { settings = { yaml = { keyOrdering = false } } }
      )
    )

    -- Odin
    lspconfig.ols.setup(config({}))

    lspconfig.clangd.setup(
      config(
        { capabilities = { offsetEncoding = { 'utf-16', 'utf-8' } } }
      )
    )

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
  end,
}
