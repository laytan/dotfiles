vim.g.tokyonight_style = 'storm'

vim.cmd('syntax on')
vim.cmd('colorscheme tokyonight')

-- Transparancy
vim.cmd(
  [[
hi Normal guibg=NONE ctermbg=NONE
hi NormalNC guibg=NONE ctermbg=NONE
hi NvimTreeNormal guibg=NONE ctermbg=NONE
hi NvimTreeNormalNC guibg=NONE ctermbg=NONE
]]
)
