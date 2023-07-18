return {
  'NeogitOrg/neogit',
  dependencies = { 'sindrets/diffview.nvim', 'nvim-lua/plenary.nvim' },
  cmd = 'Git',
  config = function()
    -- vim.env.NEOGIT_LOG_CONSOLE = true
    -- vim.env.NEOGIT_LOG_LEVEL = 'debug'
    --
    local neogit = require('neogit')

    neogit.setup(
      {
        -- disable_context_highlighting = true,
        -- disable_builtin_notifications = true,
        disable_commit_confirmation = true,

        sections = { recent = { folded = false } },
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
