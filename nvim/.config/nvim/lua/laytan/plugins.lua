local packer = require('packer')

return packer.startup(
  function(use)
    use 'wbthomason/packer.nvim'
    use 'lewis6991/impatient.nvim'
    use 'nvim-lua/plenary.nvim'

    -- Installing binaries.
    use 'williamboman/mason.nvim'
    use 'WhoIsSethDaniel/mason-tool-installer.nvim'

    -- Diagnostics & formatting (non LSP).
    use 'jose-elias-alvarez/null-ls.nvim'

    -- Snippets.
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip' -- Integrates into hrsh7th/nvim-cmp.
    use 'rafamadriz/friendly-snippets'

    -- Telescope.
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-telescope/telescope-ui-select.nvim'
    use 'nvim-telescope/telescope-live-grep-args.nvim'
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    -- Quick access to a set of files.
    use 'ThePrimeagen/harpoon'

    -- Git.
    use 'tpope/vim-fugitive'

    -- Databases.
    use 'tpope/vim-dadbod'
    use 'kristijanhusak/vim-dadbod-ui'
    use 'kristijanhusak/vim-dadbod-completion' -- Integrates into hrsh7th/nvim-cmp.

    -- Undo's navigation.
    use 'mbbill/undotree'

    use 'neovim/nvim-lspconfig'
    -- Used for the icons in the completion menu (class, function, pkg etc.).
    use 'onsails/lspkind.nvim'
    -- Show a lightbulb on lines with LSP code actions available.
    use 'kosayoda/nvim-lightbulb'

    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons' },
    }
    use {
      'kyazdani42/nvim-tree.lua',
      requires = { 'kyazdani42/nvim-web-devicons' },
    }

    use { 'Shougo/nvim-cmp', branch = 'cmdheight' }
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'davidsierradz/cmp-conventionalcommits'
    use { 'tzachar/cmp-tabnine', run = './install.sh' }

    -- Treesitter.
    use {
      'gbprod/nvim-treesitter',
      run = ':TSUpdate',
      branch = 'introduce-twig-parser',
    }
    -- See the underlying nodes that treesitter uses and visually see results
    -- of queries.
    use { 'nvim-treesitter/playground' }
    -- Adds a context bar at the top of the buffer with the scope you are in.
    use { 'nvim-treesitter/nvim-treesitter-context' }
    -- Allows motions around language blocks (condition, class, loop etc.)
    -- Also adds switching two paramters (position).
    use { 'nvim-treesitter/nvim-treesitter-textobjects' }

    use 'numToStr/Comment.nvim'

    use { 'iamcco/markdown-preview.nvim', run = vim.fn['mkdp#util#install'] }

    use 'tpope/vim-sleuth'

    -- use 'mfussenegger/nvim-dap'
    -- use({ 'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap' } })
    -- use(
    --   {
    --     'theHamsta/nvim-dap-virtual-text',
    --     requires = { 'mfussenegger/nvim-dap' },
    --   }
    -- )
    -- use(
    --   {
    --     'leoluz/nvim-dap-go',
    --     config = function()
    --       require('dap-go').setup()
    --     end,
    --   }
    -- )

    -- See https://github.com/neovim/neovim/pull/19243.
    use {
      'luukvbaal/stabilize.nvim',
      config = function()
        require('stabilize').setup()
      end,
    }

    use 'folke/todo-comments.nvim'

    use 'stevearc/aerial.nvim'

    use 'rcarriga/nvim-notify'

    use 'j-hui/fidget.nvim'

    use {
      'olexsmir/gopher.nvim',
      config = function()
        require('gopher').setup({})
      end,
    }

    use 'stevearc/overseer.nvim'

    use 'andrewferrier/debugprint.nvim'

    use 'NvChad/nvim-colorizer.lua'

    use '~/projects/cloak.nvim'

    use {
      'phaazon/mind.nvim',
      config = function()
        require('mind').setup()
      end,
    }

    use 'lewis6991/hover.nvim'

    use { 'catppuccin/nvim', as = 'catppuccin', run = ':CatppuccinCompile' }

    use {
      'kylechui/nvim-surround',
      config = function()
        require('nvim-surround').setup()
      end,
    }

    use 'gen740/SmoothCursor.nvim'

    use {
      'petertriho/nvim-scrollbar',
      config = function()
        require('scrollbar').setup()
      end,
    }

    use 'vim-scripts/ReplaceWithRegister'

    use 'ellisonleao/glow.nvim'
    use 'm00qek/baleia.nvim'
  end
)
