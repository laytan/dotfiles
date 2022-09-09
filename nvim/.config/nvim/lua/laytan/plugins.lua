local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  Packer_bootstrap = fn.system(
    {
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/wbthomason/packer.nvim',
      install_path,
    }
  )
  vim.cmd [[packadd packer.nvim]]
end

-- Compile catppuccin after packer compiles.
vim.api.nvim_create_autocmd(
  'User', {
    pattern = 'PackerCompileDone',
    callback = function()
      vim.cmd 'CatppuccinCompile'
      vim.defer_fn(
        function()
          vim.cmd 'colorscheme catppuccin'
        end, 0
      ) -- Defered for live reloading
    end,
  }
)

local packer = require('packer')
return packer.startup(
  function(use)
    use({ 'lewis6991/impatient.nvim' })

    -- Fix for https://github.com/neovim/neovim/issues/12587
    use(
      {
        'antoinemadec/FixCursorHold.nvim',
        config = function()
          vim.g.cursorhold_updatetime = 500
        end,
      }
    )

    -- External packages installer
    use({ 'williamboman/mason.nvim' })
    use({ 'WhoIsSethDaniel/mason-tool-installer.nvim' })

    -- Needs ripgrep
    use(
      {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } },
      }
    )
    -- Needs cmake, make, (gcc or clang)
    use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })
    use({ 'nvim-telescope/telescope-ui-select.nvim' })
    use({ 'nvim-telescope/telescope-live-grep-args.nvim' })

    use({ 'L3MON4D3/LuaSnip' })
    use({ 'rafamadriz/friendly-snippets' })

    use({ 'jose-elias-alvarez/null-ls.nvim', requires = { 'nvim-lua/plenary.nvim' } })

    use({ 'ThePrimeagen/harpoon', requires = { 'nvim-lua/plenary.nvim' } })

    use(
      {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
      }
    )

    use({ 'tpope/vim-fugitive' })

    use(
      {
        'mbbill/undotree',
        cmd = 'UndotreeToggle',
        setup = function()
          vim.keymap.set('n', '<leader>u', ':UndotreeToggle<cr>')
        end,
      }
    )

    -- LSP enhancement
    use({ 'neovim/nvim-lspconfig' })
    use({ 'onsails/lspkind.nvim' })
    use({ 'kosayoda/nvim-lightbulb' })

    use({ 'hrsh7th/nvim-cmp' })
    use({ 'saadparwaiz1/cmp_luasnip', requires = { 'L3MON4D3/LuaSnip' } })
    use({ 'hrsh7th/cmp-nvim-lsp' })
    use({ 'hrsh7th/cmp-buffer' })
    use({ 'hrsh7th/cmp-path' })
    use({ 'hrsh7th/cmp-cmdline' })
    use({ 'davidsierradz/cmp-conventionalcommits' })
    -- requires curl & unzip
    use({ 'tzachar/cmp-tabnine', run = './install.sh' })

    -- requires tar & curl or git and gcc or clang
    use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
    use(
      {
        'nvim-treesitter/playground',
        cmd = 'TSPlaygroundToggle',
        requires = { 'nvim-treesitter/nvim-treesitter' },
      }
    )
    use(
      {
        'nvim-treesitter/nvim-treesitter-context',
        requires = { 'nvim-treesitter/nvim-treesitter' },
      }
    )
    use(
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        requires = { 'nvim-treesitter/nvim-treesitter' },
      }
    )

    use(
      {
        'numToStr/Comment.nvim',
        config = function()
          require('Comment').setup()
        end,
      }
    )

    use(
      {
        'iamcco/markdown-preview.nvim',
        run = function()
          vim.fn['mkdp#util#install']()
        end,
      }
    )

    use({ 'tpope/vim-sleuth' })

    use(
      {
        'kyazdani42/nvim-tree.lua',
        requires = { 'kyazdani42/nvim-web-devicons' },
      }
    )

    use(
      { 'inkarkat/vim-SyntaxRange', requires = { 'inkarkat/vim-ingo-library' } }
    )

    use({ 'mfussenegger/nvim-dap' })
    use({ 'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap' } })
    use(
      {
        'theHamsta/nvim-dap-virtual-text',
        requires = { 'mfussenegger/nvim-dap' },
      }
    )
    use(
      {
        'leoluz/nvim-dap-go',
        config = function()
          require('dap-go').setup()
        end,
      }
    )

    use(
      {
        'tpope/vim-dadbod',
        setup = function()
          vim.g.db_ui_auto_execute_table_helpers = 1
        end,
      }
    )
    use({ 'kristijanhusak/vim-dadbod-ui', requires = { 'tpope/vim-dadbod' } })
    use(
      {
        'kristijanhusak/vim-dadbod-completion',
        requires = { 'tpope/vim-dadbod' },
      }
    )

    use(
      {
        'luukvbaal/stabilize.nvim',
        config = function()
          require('stabilize').setup()
        end,
      }
    )

    use({ 'folke/todo-comments.nvim' })

    use({ 'phaazon/hop.nvim', branch = 'v2' })
    use({ 'rlane/pounce.nvim' })

    use({ 'stevearc/aerial.nvim' })

    use(
      {
        'rcarriga/nvim-notify',
        config = function()
          local notify = require('notify')
          notify.setup({ timeout = 1500, background_colour = '#000000' })

          vim.notify = notify
        end,
      }
    )

    use(
      {
        'j-hui/fidget.nvim',
        config = function()
          -- catppuccin window blend
          require('fidget').setup({ window = { blend = 0 } })
        end,
      }
    )

    use({ 'nelsyeung/twig.vim' })

    use(
      {
        'olexsmir/gopher.nvim',
        requires = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
        config = function()
          require('gopher').setup({})
        end,
      }
    )

    -- Pretty buggy, cool idea though
    -- use(
    --   {
    --     'nvim-neotest/neotest',
    --     requires = {
    --       'nvim-lua/plenary.nvim',
    --       'nvim-treesitter/nvim-treesitter',
    --       'antoinemadec/FixCursorHold.nvim',
    --     },
    --   }
    -- )
    -- use({ 'nvim-neotest/neotest-go', requires = { 'nvim-neotest/neotest' } })

    use({ 'stevearc/overseer.nvim' })

    use(
      {
        'andrewferrier/debugprint.nvim',
        config = function()
          require('debugprint').setup(
            {
              filetypes = {
                ['php'] = {
                  left = [[dump(']],
                  right = [[');]],
                  mid_var = [[', $]],
                  right_var = [[);]],
                },
              },
            }
          )
        end,
      }
    )

    use(
      {
        'norcalli/nvim-colorizer.lua',
        config = function()
          require('colorizer').setup()
        end,
      }
    )

    use({ 'dstein64/vim-startuptime' })

    use({ '~/projects/cloak.nvim' })

    use(
      {
        'phaazon/mind.nvim',
        branch = 'v2',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
          require('mind').setup()
        end,
      }
    )

    use({ '~/projects/hover.nvim' })

    use({ 'catppuccin/nvim', as = 'catppuccin', run = ':CatppuccinCompile' })

    if Packer_bootstrap then
      packer.sync()
    end
  end
)

