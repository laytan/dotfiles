return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'catppuccin', 'ThePrimeagen/harpoon' },
  config = function()
    local search = require('laytan.lualine.search')
    local harpoon = require('laytan.lualine.harpoon')

    require('lualine').setup(
      {
        options = { theme = 'catppuccin' },
        sections = {
          lualine_x = {
            {
              require('lazy.status').updates,
              cond = require('lazy.status').has_updates,
              color = { fg = '#ff9e64' },
            },
            'filetype',
          },
          lualine_y = { search, 'progress' },
        },
        tabline = {
          lualine_c = { harpoon },
          lualine_z = { { 'tabs', mode = 2 } },
        },
      }
    )
  end,
}
