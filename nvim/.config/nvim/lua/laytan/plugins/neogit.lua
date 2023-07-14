return {
  'TimUntersberger/neogit',
  -- 'CKolkey/neogit',
  dependencies = { 'sindrets/diffview.nvim' },
  cmd = 'Git',
  config = function()
    -- vim.env.NEOGIT_LOG_CONSOLE = true
    -- vim.env.NEOGIT_LOG_LEVEL = 'debug'
    --
    local neogit = require('neogit')

    neogit.setup(
      {
        disable_context_highlighting = true,
        disable_builtin_notifications = true,

        sections = { recent = { folded = false } },
        integrations = { diffview = true, telescope = true },
      }
    )

    vim.api.nvim_create_user_command(
      'Git', function()
        neogit.open()
      end, {}
    )
  end,
}
