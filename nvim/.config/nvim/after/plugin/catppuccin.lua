local catppuccin = require('catppuccin')

vim.g.catppuccin_flavour = 'macchiato'

catppuccin.setup({
    transparent_background = true,
    compile = {enabled = true},
    integrations = {
        aerial = true,
        cmp = true,
        fidget = true,
        hop = true,
        notify = true,
        nvimtree = true,
        overseer = true,
        pounce = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        dap = {enabled = true, enable_ui = true},
        native_lsp = {enabled = true}
    }

})

vim.cmd('colorscheme catppuccin')

