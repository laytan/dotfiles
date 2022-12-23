local neogit = require('neogit')

neogit.setup({
  disable_context_highlighting = true,
  disable_builtin_notifications = true,

  sections = {
    recent = {
      folded = false,
    },
  },
})

vim.api.nvim_create_user_command('Git', function()
  neogit.open()
end, {})
