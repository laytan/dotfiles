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
        compile = { enabled = true },
        integrations = {
          aerial = true,
          cmp = true,
          fidget = true,
          nvimtree = true,
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

    local function customizations()
      vim.cmd([[hi WinSeparator guifg=#363a4f]])
      vim.cmd([[hi TreesitterContext guibg=#363a4f]])
      vim.cmd([[hi TreesitterContextBottom NONE]])
      vim.cmd([[hi NormalFloat guibg=#24273a]])
      vim.cmd([[hi Normal guibg=#1E1E2E]])
      vim.cmd([[hi LightBulbVirtualText guibg=#1E1E2E]])
    end

    vim.cmd('colorscheme catppuccin')
    customizations()

    -- Compile catppuccin after Lazy compiles.
    vim.api.nvim_create_autocmd(
      'User', {
        pattern = { 'LazySync', 'LazyInstall', 'LazyUpdate', 'LazyClean' },
        callback = function()
          vim.cmd('CatppuccinCompile')
          vim.defer_fn(
            function()
              vim.cmd('colorscheme catppuccin')
              customizations()
            end, 0
          ) -- Deferred for live reloading
        end,
      }
    )
  end,
}
