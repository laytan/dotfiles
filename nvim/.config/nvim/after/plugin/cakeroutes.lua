local cakeroutes = require('cakeroutes')

cakeroutes.setup()

vim.keymap.set(
  'n', '<leader>tcr', function()
    cakeroutes.picker()
  end
)

