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
