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
            -- Only shows overseer if it is loaded. TODO: this still loads overseer on first load.
            -- { 'overseer', cond = function() return vim.fn.exists(':OverseerInfo') > 0 end },
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
