-- Colorscheme.
return {
  'catppuccin/nvim',
  name = 'catppuccin',
  build = ':CatppuccinCompile',
  config = function()
    local catppuccin = require('catppuccin')

    vim.g.catppuccin_flavour = 'macchiato'

    catppuccin.setup(
      {
        transparent_background = true,
        compile = { enabled = true },
        integrations = {
          aerial = true,
          cmp = true,
          fidget = true,
          notify = true,
          nvimtree = true,
          overseer = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          dap = { enabled = true, enable_ui = true },
          native_lsp = { enabled = true },
          harpoon = true,
          mason = true,
          neogit = true,
        },
      }
    )

    vim.cmd('colorscheme catppuccin')

    -- Compile catppuccin after Lazy compiles.
    vim.api.nvim_create_autocmd(
      'User', {
        pattern = { 'LazySync', 'LazyInstall', 'LazyUpdate', 'LazyClean' },
        callback = function()
          vim.cmd('CatppuccinCompile')
          vim.defer_fn(
            function()
              vim.cmd('colorscheme catppuccin')
            end, 0
          ) -- Deferred for live reloading
        end,
      }
    )

    vim.cmd([[hi WinSeparator guifg=#363a4f]])

  end,
}
