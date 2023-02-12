return {
  -- Dependency of lots of plugins.
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'kyazdani42/nvim-web-devicons', lazy = true },

  { 'folke/neodev.nvim', lazy = true, config = true },

  -- Pretty vim.notify output.
  {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require('notify')
      notify.setup({ timeout = 1500, background_colour = '#000000' })
      vim.notify = notify
    end,
  },

  { 'lewis6991/gitsigns.nvim', config = true, event = 'BufEnter' },

  {
    'rhysd/git-messenger.vim',
    keys = '<leader>gm',
    cmd = 'GitMessenger',
    config = function()
      vim.g.git_messenger_always_into_popup = true
    end,
  },

  -- Undo navigation.
  {
    'mbbill/undotree',
    keys = '<leader>u',
    config = function()
      vim.keymap.set('n', '<leader>u', ':silent :UndotreeToggle<cr>')
    end,
  },

  -- Better and language aware commenting.
  { 'numToStr/Comment.nvim', event = 'BufEnter', config = true },

  -- Live preview markdown.
  {
    'iamcco/markdown-preview.nvim',
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    -- CmdlineEnter so we get auto-complete for the commands.
    event = 'CmdlineEnter',
  },

  -- GO utility and debugging.
  { 'olexsmir/gopher.nvim', ft = 'go', config = true },

  -- Powerful note taking.
  -- CmdlineEnter so we get auto-complete for the commands.
  { 'phaazon/mind.nvim', branch = 'v2.2', event = 'CmdlineEnter', config = true },

  -- Powerful surround textobjects/actions.
  { 'kylechui/nvim-surround', event = 'VeryLazy', config = true },

  -- Put but without clearing put register.
  { 'vim-scripts/ReplaceWithRegister', event = 'VeryLazy' },

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

  -- Shortcuts for inserting and removing debug and print statements.
  {
    'andrewferrier/debugprint.nvim',
    event = 'VeryLazy',
    opts = {
      filetypes = {
        ['php'] = {
          left = [[ray(']],
          right = [[');]],
          mid_var = [[', $]],
          right_var = [[);]],
        },
      },
    },
  },

  -- Colors text that resolves to a color in that color (works with Sass variables).
  {
    'NvChad/nvim-colorizer.lua',
    event = 'BufEnter',
    opts = {
      user_default_options = {
        rgb_fn = true,
        hsl_fn = true,
        tailwind = 'lsp',
        sass = { enable = true },
      },
    },
  },

  { 'shortcuts/no-neck-pain.nvim', version = '*', event = 'CmdlineEnter' },
}
