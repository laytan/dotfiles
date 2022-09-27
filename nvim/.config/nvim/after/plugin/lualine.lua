local search = require('laytan.lualine.search')
local harpoon = require('laytan.lualine.harpoon')

require('lualine').setup(
  {
    options = { theme = 'catppuccin' },
    sections = {  lualine_x = { 'overseer', 'filetype' }, lualine_y = { search, 'progress' } },
    tabline = { lualine_c = { harpoon }, lualine_z = { { 'tabs', mode = 2 } } },
  }
)
