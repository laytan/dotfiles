-- Git (my fork of neogit).
return {
  '~/projects/neogit',
  dependencies = { 'sindrets/diffview.nvim' },
  cmd = 'Git',
  dev = true,
  config = function()
    local neogit = require('neogit')

    neogit.setup(
      {
        disable_context_highlighting = true,
        disable_builtin_notifications = true,

        sections = { recent = { folded = false } },
        integrations = { diffview = true },
      }
    )

    vim.api.nvim_create_user_command(
      'Git', function()
        neogit.open()
      end, {}
    )
  end,
}
