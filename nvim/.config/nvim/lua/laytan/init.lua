require('laytan.install')()
require('laytan.plugins')
require('laytan.set')
require('laytan.keymaps')
require('laytan.autocommands')
require('laytan.colors')
require('laytan.drupal')
require('laytan.git')

require('cmp_jira')

-- Quick way to make this run after plugin configuration
vim.defer_fn(
  function()
    local cwd = vim.fn.getcwd()

    if cwd:sub(-#'mcm') == 'mcm' then
      require('laytan.projects.mcm')
    end
  end, 1000
)

