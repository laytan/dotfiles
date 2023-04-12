require('laytan.install')
require('laytan.set')
require('laytan.ft')
require('laytan.statuscol')
require('lazy').setup('laytan.plugins', { checker = { enabled = true } })
require('laytan.keymaps')
require('laytan.autocommands')
require('laytan.git')

vim.api.nvim_create_autocmd(
  'User', {
    pattern = 'VeryLazy',
    callback = function()
      vim.schedule(
        function()
          local cwd = vim.fn.getcwd()

          if cwd:sub(-#'mcm') == 'mcm' then
            require('laytan.projects.mcm')
          end
        end
      )
    end,
  }
)
