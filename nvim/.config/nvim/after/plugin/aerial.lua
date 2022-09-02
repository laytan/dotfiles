require('aerial').setup(
  {
    on_attach = function(bufnr)
      vim.api.nvim_buf_set_keymap(
        bufnr, 'n', '<leader>fo', '<cmd>AerialToggle float<CR>', {}
      )

      vim.api.nvim_buf_set_keymap(bufnr, 'n', '[[', '<cmd>AerialPrev<CR>', {})
      vim.api.nvim_buf_set_keymap(bufnr, 'n', ']]', '<cmd>AerialNext<CR>', {})
    end,
    width = 45,
    highlight_on_jump = false,
    close_behavior = 'close',
    close_on_select = true,
  }
)
