require('laytan.install')
require('laytan.set')
require('laytan.statuscol')
require('lazy').setup('laytan.plugins', {
  dev = {
    path     = '~/projects',
    patterns = { 'laytan' },
    fallback = true,
  },
  checker = {
    enabled      = true,
    check_pinned = true,
    frequency    = 60 * 60 * 24 * 2, -- 2 days
  },
  change_detection = { enabled = false, },
})
require('laytan.quick_command').setup()
require('laytan.lsp_focus').setup()
require('laytan.keymaps')
require('laytan.autocommands')
