require('nvim-treesitter.configs').setup(
  {
    highlight = { enable = true },
    playground = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['ib'] = '@block.inner',
          ['ab'] = '@block.outer',
          ['a/'] = '@comment.outer',
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
