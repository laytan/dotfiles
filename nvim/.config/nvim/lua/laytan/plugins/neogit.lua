return {
  'NeogitOrg/neogit',
  dependencies = { 'sindrets/diffview.nvim', 'nvim-lua/plenary.nvim' },
  cmd = 'Git',
  keys = {{ '<leader>gg', ':silent :Git<cr>' }},
  config = function()
    -- vim.env.NEOGIT_LOG_CONSOLE = true
    -- vim.env.NEOGIT_LOG_LEVEL = 'debug'
    --
    local neogit = require('neogit')

    neogit.setup(
      {
        graph_style = 'unicode',
        disable_commit_confirmation = true,
        sections = { recent = { folded = false, hidden = false } },
        integrations = { diffview = true, telescope = true },
      }
    )

    vim.api.nvim_create_user_command(
      'Git', function()
        neogit.open({ kind = 'split' })
      end, {}
    )
  end,
}
