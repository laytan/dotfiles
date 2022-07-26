local hover = require('hover')
local lsp_time = require('laytan.lsp_time')

hover.setup(
  {
    init = function()
      require('hover.providers.lsp')
      require('hover.providers.dictionary')
      require('hover.providers.jira')
      require('laytan.hover.gh_repos')
    end,
    preview_opts = { border = false },
    title = false,
  }
)

vim.keymap.set(
  'n', '<leader>hh', function()
  -- TODO: can we decorate the client.request function so it works in this
  -- TODO: context?
  -- lsp_time.signal_start('textDocument/hover')
  hover.hover()
end
)

-- laytan/shortnr
