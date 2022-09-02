local hop = require('hop')
local hint = require('hop.hint')
hop.setup({})

vim.keymap.set('n', 's', ':HopWord<cr>')
vim.keymap.set('n', 'S', ':HopChar1<cr>')
vim.keymap.set(
  'n', 'f', function()
    hop.hint_char1(
      { direction = hint.HintDirection.AFTER_CURSOR, current_line_only = true }
    )
  end
)
vim.keymap.set(
  'n', 'F', function()
    hop.hint_char1(
      { direction = hint.HintDirection.BEFORE_CURSOR, current_line_only = true }
    )
  end
)
vim.keymap.set(
  'n', 't', function()
    hop.hint_char1(
      {
        direction = hint.HintDirection.BEFORE_CURSOR,
        current_line_only = true,
        hint_offset = -1,
      }
    )
  end
)
vim.keymap.set(
  'n', 'T', function()
    hop.hint_char1(
      {
        direction = hint.HintDirection.BEFORE_CURSOR,
        current_line_only = true,
        hint_offset = -1,
      }
    )
  end
)
