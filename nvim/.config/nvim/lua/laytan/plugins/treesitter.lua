-- Treesitter.
return {
  'nvim-treesitter/nvim-treesitter', -- Core functionality for treesitter.
  dependencies = {
    'nvim-treesitter/playground', -- Allows visualization of the treesitter tree and queries.
    'nvim-treesitter/nvim-treesitter-context', -- Adds a context bar at the top of the buffer with the scope you are in.
    -- Allows motions around language blocks (condition, class, loop etc.)
    -- Also adds switching two parameters (position).
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  build = function()
    require('nvim-treesitter.install').update({ with_sync = true })
  end,
  event = 'BufReadPre',
  config = function()
    require('nvim-treesitter.configs').setup(
      {
        highlight = { enable = true },
        playground = { enable = true },
        textobjects = {
          include_surrounding_whitespace = true,
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['ii'] = '@conditional.inner',
              ['ai'] = '@conditional.outer',
              ['a/'] = '@comment.outer',
              ['al'] = '@loop.outer',
              ['il'] = '@loop.inner',
            },
          },
          swap = {
            enable = true,
            swap_next = { ['<leader>s'] = '@parameter.inner' },
            swap_previous = { ['<leader>S'] = '@parameter.inner' },
          },
        },
      }
    )
  end,
}
