return {
  -- Adds custom hover actions for things like github repos, jira tickets, etc.
  'lewis6991/hover.nvim',
  dependencies = {
    'ellisonleao/glow.nvim', -- Used in the custom GitHub repo hover action to render markdown in Neovim.
    'm00qek/baleia.nvim', -- Used in the custom GitHub repo hover action to render ANSI escape sequences in Neovim.
  },
  keys = {
    {
      '<leader>hh',
      function()
        require('hover').hover()
      end,
    },
  },
  opts = {
    init = function()
      require('hover.providers.lsp')
      require('hover.providers.jira')
      require('laytan.hover.gh_repos')
    end,
    preview_opts = { border = false },
    preview_window = true,
    title = false,
  },
}
