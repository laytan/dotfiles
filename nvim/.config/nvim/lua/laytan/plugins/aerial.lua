-- Visualize/traverse code structure using treesitter.
return {
  'stevearc/aerial.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  keys = { '<C-r>', '<C-t>', '<leader>fo' },
  config = function()
    local on_attach = function(bufnr)
      vim.api.nvim_buf_set_keymap(
        bufnr, 'n', '<leader>fo', '<cmd>AerialToggle float<CR>', {}
      )

      vim.api
        .nvim_buf_set_keymap(bufnr, 'n', '<C-r>', '<cmd>AerialPrev<CR>', {})
      vim.api
        .nvim_buf_set_keymap(bufnr, 'n', '<C-t>', '<cmd>AerialNext<CR>', {})
    end

    require('aerial').setup(
      {
        on_attach = on_attach,
        layout = { width = 45 },
        highlight_on_jump = false,
        close_on_select = true,
        close_automatic_events = { 'switch_buffer' },
      }
    )

    on_attach(vim.fn.bufnr())
  end,
}
