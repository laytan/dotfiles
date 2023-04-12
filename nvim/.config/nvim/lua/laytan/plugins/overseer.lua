-- Managing and easy executing of tasks like sass, make etc.
return {
  -- dir = '~/projects/overseer.nvim',
  'stevearc/overseer.nvim',
  keys = {
    { '<leader>oa', ':silent :OverseerTaskAction<cr>' },
    { '<leader>ov', ':silent :OverseerToggle! right<cr>' },
    { '<leader>or', ':silent :OverseerRun<cr>' },
  },
  config = true,
}
