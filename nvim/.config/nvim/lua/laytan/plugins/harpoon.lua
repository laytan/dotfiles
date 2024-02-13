-- Quick access to set of files.
return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
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
    local harpoon = require('harpoon')
    harpoon:setup({})

    vim.keymap.set(
      'n', '<leader>ha', function()
        harpoon:list():append()
      end
    )
    vim.keymap.set(
      'n', '<leader>hd', function()
        harpoon:list():remove()
      end
    )
    vim.keymap.set(
      'n', '<leader>hc', function()
        harpoon:list():clear()
      end
    )
    vim.keymap.set(
      'n', '<leader>hl', function()
        harpoon.ui.toggle_quick_menu(harpoon:list())
      end
    )
    vim.keymap.set(
      'n', '<leader>j', function()
        harpoon:list():select(1)
      end
    )
    vim.keymap.set(
      'n', '<leader>k', function()
        harpoon:list():select(2)
      end
    )
    vim.keymap.set(
      'n', '<leader>l', function()
        harpoon:list():select(3)
      end
    )
    vim.keymap.set(
      'n', '<leader>;', function()
        harpoon:list():select(4)
      end
    )
  end,
}
