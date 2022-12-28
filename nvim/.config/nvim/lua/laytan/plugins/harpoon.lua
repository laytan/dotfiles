-- Quick access to set of files.
return {
  'ThePrimeagen/harpoon',
  keys = {
    '<leader>ha',
    '<leader>hd',
    '<leader>hc',
    '<leader>hl',
    '<leader>j',
    '<leader>k',
    '<leader>l',
    '<leader>;',
  },
  config = function()
    local mark = require('harpoon.mark')
    local ui = require('harpoon.ui')

    vim.keymap.set(
      'n', '<leader>ha', function()
      mark.add_file()
    end
    )
    vim.keymap.set(
      'n', '<leader>hd', function()
      mark.rm_file()
    end
    )
    vim.keymap.set(
      'n', '<leader>hc', function()
      mark.clear_all()
    end
    )
    vim.keymap.set(
      'n', '<leader>hl', function()
      ui.toggle_quick_menu()
    end
    )
    vim.keymap.set(
      'n', '<leader>j', function()
      ui.nav_file(1)
    end
    )
    vim.keymap.set(
      'n', '<leader>k', function()
      ui.nav_file(2)
    end
    )
    vim.keymap.set(
      'n', '<leader>l', function()
      ui.nav_file(3)
    end
    )
    vim.keymap.set(
      'n', '<leader>;', function()
      ui.nav_file(4)
    end
    )
  end,
}
