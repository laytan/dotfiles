return {
  -- Dependency of lots of plugins.
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  { 'folke/neodev.nvim', lazy = true, config = true },

  { 'm00qek/baleia.nvim', lazy = true },

  {
    'williamboman/mason.nvim',
    config = true,
    cmd = 'Mason',
  },

  {
    'stevearc/oil.nvim',
    opts = {
      delete_to_trash = true,
      view_options = {
        show_hidden = true,
      },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = { { '-', ':Oil<cr>' } },
  },

  {
    'nvim-pack/nvim-spectre',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
    cmd = 'Spectre',
    keys = {
      {
        '<leader>sr',
        '<cmd>lua require("spectre").toggle()<CR>',
        desc = 'Toggle Spectre',
      },
      {
        '<leader>sw',
        '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
        desc = 'Search current word',
      },
    },
  },

  {
    {
      'laytan/tailwind-sorter.nvim',
      dir = "~/projects/tailwind-sorter.nvim",
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
      build = 'cd formatter && npm i && npm run build',
      config = true,
      event = 'CmdlineEnter',
    },
  },

  -- Normal buffer/vim operations on the quickfix list.
  { 'itchyny/vim-qfedit' },

  { 'lewis6991/gitsigns.nvim', config = true, event = 'BufEnter' },

  {
    'm4xshen/smartcolumn.nvim',
    opts = { colorcolumn = '100' },
    event = 'BufEnter',
  },

  {
    'mbbill/undotree',
    keys = '<leader>u',
    config = function()
      vim.keymap.set('n', '<leader>u', ':silent :UndotreeToggle<cr>')
    end,
  },

  { 'numToStr/Comment.nvim', event = 'BufEnter', config = true },

  {
    'iamcco/markdown-preview.nvim',
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    -- CmdlineEnter so we get auto-complete for the commands.
    event = 'CmdlineEnter',
  },

  -- Powerful surround textobjects/actions.
  { 'kylechui/nvim-surround', event = 'VeryLazy', config = true },

  -- Put but without clearing put register.
  {
    'vim-scripts/ReplaceWithRegister',
    keys = { { 'gr', nil, 'x' }, 'gr', 'grr' },
  },

  -- Quickly spin up a local server for files.
  {
    'aurum77/live-server.nvim',
    build = function()
      require('live_server.util').install()
    end,
    -- CmdlineEnter so we get auto-complete for the commands.
    event = 'CmdlineEnter',
    config = true,
  },

  {
    'olexsmir/gopher.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = true,
    ft = 'go',
  },

  -- Shortcuts for inserting and removing debug and print statements.
  {
    'andrewferrier/debugprint.nvim',
    event = 'VeryLazy',
    opts = {
      filetypes = {
        ['php'] = {
          left      = [[dump(']],
          right     = [[');]],
          mid_var   = [[', $]],
          right_var = [[);]],
        },
        ['odin'] = {
          left      = [[fmt.printf("]],
          right     = [[")]],
          mid_var   = [[", ]],
          right_var = [[)]],
        },
      },
    },
  },
}
