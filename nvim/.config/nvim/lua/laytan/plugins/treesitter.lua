-- Treesitter.
return {
  'nvim-treesitter/nvim-treesitter', -- Core functionality for treesitter.
  dependencies = {
    'nvim-treesitter/nvim-treesitter-context', -- Adds a context bar at the top of the buffer with the scope you are in.
  },
  build = function()
    require('nvim-treesitter.install').update({ with_sync = true })
  end,
  event = 'BufReadPre',
  config = function()
    require('nvim-treesitter.configs').setup(
      {
        -- Install the basics.
        ensure_installed = {
          'bash',
          'dockerfile',
          'gitcommit',
          'json',
          'yaml',
          'markdown',
          'markdown_inline',
          'query', -- Treesitter queries.
          'make',
          'regex',
          'vimdoc', -- :help pages.
          'lua',
          'luadoc',
          'luap', -- Lua patterns.
        },
        highlight = { enable = true },
        indent = { enable = true },
      }
    )

    require('treesitter-context').setup({ line_numbers = false })

    vim.api.nvim_create_user_command("TSPlayground", ":InspectTree", {})
  end,
}
