local overseer = require('overseer')
overseer.setup({})

vim.keymap.set('n', '<leader>ov', ':silent :OverseerToggle! right<cr>')
vim.keymap.set('n', '<leader>oa', ':silent :OverseerTaskAction<cr>')
vim.keymap.set('n', '<leader>or', ':silent :OverseerRun<cr>')

overseer.register_template(
  {
    name = 'Go test',
    builder = function()
      return {
        cmd = { 'go', 'test', './...', '-cover', '-race', '-timeout=5s', '-v' },
      }
    end,
    desc = 'Run the Go testing suite',
    params = {},
    condition = { filetype = 'go' },
  }
)
