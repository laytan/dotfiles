local ls = require('luasnip')
local types = require('luasnip.util.types')
local icons = require('nvim-web-devicons')
ls.config.set_config(
  {
    updateevents = 'TextChanged,TextChangedI',
    ext_opts = {
      [types.choiceNode] = {
        active = { virt_text = { { icons.get_icon('Rmd'), 'Bold' } } },
      },
    },
  }
)

require('luasnip.loaders.from_lua').load(
  { paths = '~/.config/nvim/lua/laytan/snips/ft' }
)

-- Loads the snippets from 'rafamadriz/friendly-snippets'
require('luasnip.loaders.from_vscode').load()
require('luasnip').filetype_extend('vue', { 'vue' })
require('luasnip').filetype_extend('twig', { 'twig' })

vim.keymap.set(
  { 'i', 's' }, '<c-k>', function()
    if ls.jumpable(1) then
      ls.jump(1)
    end
  end, { silent = true }
)

vim.keymap.set(
  { 'i', 's' }, '<c-j>', function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end, { silent = true }
)

vim.keymap.set(
  'i', '<c-l>', function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end
)
