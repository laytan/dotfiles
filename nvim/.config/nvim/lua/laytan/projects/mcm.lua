local cakeroutes = require('cakeroutes')

vim.g.ale_php_phpcs_standard = 'PSR12'
vim.g.ale_fix_on_save = 0

cakeroutes.setup(
  {
    cache = true,
    cmd = { 'docker', 'exec', '-i', 'mcm_mcm', 'bin/cake', 'routes' },
  }
)

vim.keymap.set(
  'n', '<leader>tcr', function()
    cakeroutes.picker()
  end
)

