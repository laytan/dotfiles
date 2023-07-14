return {
  'mrjones2014/smart-splits.nvim',
  keys = {
    {
      '¬', -- Alt-l
      function()
        require('smart-splits').resize_right()
      end,
    },
    {
      '∆', -- Alt-j
      function()
        require('smart-splits').resize_down()
      end,
    },
    {
      '˚', -- Alt-k
      function()
        require('smart-splits').resize_up()
      end,
    },
    {
      '˙', -- Alt-h
      function()
        require('smart-splits').resize_left()
      end,
    },
    {
      '<C-l>',
      function()
        require('smart-splits').move_cursor_right()
      end
    },
    {
      '<C-j>',
      function()
        require('smart-splits').move_cursor_down()
      end
    },
    {
      '<C-k>',
      function()
        require('smart-splits').move_cursor_up()
      end
    },
    {
      '<C-h>',
      function()
        require('smart-splits').move_cursor_left()
      end
    },
    {
      '<leader><leader>l',
      function()
        require('smart-splits').swap_buf_right()
      end
    },
    {
      '<leader><leader>j',
      function()
        require('smart-splits').swap_buf_down()
      end
    },
    {
      '<leader><leader>k',
      function()
        require('smart-splits').swap_buf_up()
      end
    },
    {
      '<leader><leader>h',
      function()
        require('smart-splits').swap_buf_left()
      end
    },
  },
  opts = { silent = true },
}
