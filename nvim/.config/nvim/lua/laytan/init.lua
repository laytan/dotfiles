require('laytan.set')

vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind

  if name == 'live-server.nvim' and (kind == 'install' or kind == 'update') then
    require('live-server.util').install()
  end

  -- if name == 'cmp-tabnine' and (kind == 'install' or kind == 'update') then
  --   vim.system({'./install.sh'}, { cwd = ev.data.path })
  -- end

  if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
    vim.system({'make'}, { cwd = ev.data.path })
  end

  if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
    vim.cmd('TSUpdate')
  end

  pcall(function()
    vim.cmd('CatppuccinCompile')
    catppuccin()
  end)
end })

local gh = function(x) return 'https://github.com/' .. x end
vim.pack.add({
  gh('nvim-lua/plenary.nvim'),
  gh('m00qek/baleia.nvim'), -- quick_command
  -- gh('tpope/vim-sleuth'), -- TODO: maybe the native editorconfig works now?

  gh('nvim-tree/nvim-web-devicons'),
  gh('stevearc/oil.nvim'),

  gh('nvim-pack/nvim-spectre'),
  gh('itchyny/vim-qfedit'), -- TODO: do I use this?
  gh('lewis6991/gitsigns.nvim'),
  gh('m4xshen/smartcolumn.nvim'),
  gh('mbbill/undotree'),
  gh('numToStr/Comment.nvim'),
  gh('vim-scripts/ReplaceWithRegister'), -- TODO: learn registers.

  gh('echasnovski/mini.icons'),
  gh('rafamadriz/friendly-snippets'),
  {
    src = gh('saghen/blink.cmp'),
    version = vim.version.range('1'),
  },

  gh('catppuccin/nvim'),

  gh('nvim-neotest/nvim-nio'),
  gh('rcarriga/nvim-dap-ui'),
  gh('theHamsta/nvim-dap-virtual-text'),
  gh('mfussenegger/nvim-dap'),

  {
    src = gh('ThePrimeagen/harpoon'),
    version = 'harpoon2',
  },

  gh('j-hui/fidget.nvim'),
  gh('neovim/nvim-lspconfig'), -- TODO: can prob get rid of this?

  gh('nvim-lualine/lualine.nvim'),
  gh('NeogitOrg/neogit'),

  gh('nvim-neotest/nvim-nio'),
  gh('nvim-neotest/neotest'),

  gh('rcarriga/nvim-notify'),
  gh('stevearc/resession.nvim'),

  gh('mrjones2014/smart-splits.nvim'),

  gh('kkharji/sqlite.lua'),
  gh('prochri/telescope-all-recent.nvim'),
  gh('nvim-telescope/telescope-ui-select.nvim'),
  gh('nvim-telescope/telescope-fzf-native.nvim'),
  gh('nvim-telescope/telescope-live-grep-args.nvim'),
  gh('nvim-telescope/telescope.nvim'),

  -- TODO: move back to folke when this fork/PR is merged.
  -- https://github.com/folke/todo-comments.nvim/pull/381
  gh('belltoy/todo-comments.nvim'),

  gh('nvim-treesitter/nvim-treesitter-context'),
  gh('nvim-treesitter/nvim-treesitter'),
})

-- -- vim-sleuth
-- vim.api.nvim_create_autocmd({'BufEnter'}, {
--   command = 'silent Sleuth',
-- })

-- mason
-- require('mason').setup()

-- oil
require('oil').setup({
  delete_to_trash = true,
  view_options = {
    show_hidden = true,
  },
})
vim.keymap.set('n', '-', ':Oil<cr>')

-- spectre
require('spectre').setup()
vim.keymap.set('n', '<leader>sr', function() require('spectre').toggle() end)
vim.keymap.set('n', '<leader>sw', function() require('spectre').open_visual({select_word=true}) end)

-- gitsigns
require('gitsigns').setup()

require('smartcolumn').setup({ colorcolumn = '100' })

vim.keymap.set('n', '<leader>u', ':silent :UndotreeToggle<cr>')

require('Comment').setup()

-- require('live-server').setup()

-- require('cmp_tabnine').setup({ show_prediction_strength = true })

require('blink.cmp').setup({
  keymap = {
    preset = 'default',

    ['<C-Space>'] = {'show', 'fallback'},
    ['<C-e>'] = {'cancel', 'fallback'},
    ['<Tab>'] = {'select_and_accept', 'fallback'},
    ['<C-n>'] = {'show', 'select_next'},
  },
  appearance = {
    nerd_font_variant = 'mono',
  },

  sources = {
    default = {'lsp', 'path', 'snippets', 'buffer' },

    providers = {
      -- lazydev = {
      --   name = 'lazydev',
      --   module = 'lazydev.integrations.blink',
      --   score_offset = 100,
      -- },
      -- cmp_tabnine = {
      --   name = 'cmp_tabnine',
      --   module = 'blink.compat.source',
      -- },
    },
  },

  completion = {
    ghost_text = {
      enabled = true,
      show_with_menu = false,
    },
    menu = {
      auto_show = false,
      draw = {
        components = {
          kind_icon = {
            ellipsis = false,
            text = function (ctx)
              local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
              return kind_icon
            end,
          },
        },
      },
    },
    documentation = { auto_show = true },
  },
  signature = { enabled = true },
})
-- ??? opts_extend = { 'sources.default' },

require('catppuccin').setup({
  compile = { enabled = true },
  integrations = {
    fidget = true,
    telescope = true,
    treesitter = true,
    treesitter_context = true,
    dap = { enabled = true, enable_ui = true },
    native_lsp = { enabled = true },
    harpoon = true,
    neogit = true,
    neotest = true,
    notify = true,
  },
})

local function catppuccin()
  vim.cmd('colorscheme catppuccin-macchiato')
  vim.cmd([[hi WinSeparator guifg=#363a4f]])
  vim.cmd([[hi TreesitterContext guibg=#363a4f]])
  vim.cmd([[hi TreesitterContextBottom NONE]])
  vim.cmd([[hi NormalFloat guibg=#24273a]])
  vim.cmd([[hi Normal guibg=#1E1E2E]])
  vim.cmd([[hi LSPInlayHint guibg=#1E1E2E]])
  vim.cmd([[hi LightBulbVirtualText guibg=#1E1E2E]])
end
catppuccin()

require('laytan.dap')

require('laytan.harpoon')

require('laytan.lsp')

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'*'},
  callback = function()
    if pcall(vim.treesitter.start) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end
})
require('treesitter-context').setup({ line_numbers = false })
vim.api.nvim_create_user_command('TSPlayground', ':InspectTree', {})

require('neogit').setup({
  graph_style = 'unicode',
  disable_commit_confirmation = true,
  sections = { recent = { folded = false, hidden = false } },
  integrations = { diffview = true, telescope = true },
})
vim.keymap.set('n', '<leader>gg', function() require('neogit').open({ kind = 'split' }) end)

require('neotest').setup({
  adapters = {
    require('laytan.neotest-odin'),
  },
})
vim.keymap.set('n', '<leader>vs', ':Neotest summary<cr>')
vim.keymap.set('n', '<leader>vr', ':Neotest run<cr>')
vim.keymap.set('n', '<leader>vd', function() require('neotest').run.run({ strategy = 'dap' }) end)
vim.keymap.set('n', '<leader>vo', ':Neotest output-panel<cr>')

require('laytan.smart-splits')

require('laytan.telescope')

require('todo-comments').setup({
  -- Most of this setup is so the format of PHP/PHPCS is accepted.
  -- That is: "@todo this needs to be done."
  -- FIX: a
  -- FIXME: b
  -- BUG: c
  -- FIXIT: d
  -- ISSUE: e
  -- TODO: a
  -- @todo: b
  -- NOTE: a
  -- HACK: a
  -- WARN: b
  -- WARNING: c
  -- XXX: d
  -- PERF: a
  -- OPTIM: b
  highlight = { pattern = [[.*<(KEYWORDS)\s*]] },
  search = { pattern = [[\b(KEYWORDS)\b]] },
  keywords = { TODO = { alt = { 'todo' } } },
})
vim.keymap.set('n', '<leader>td', ':silent :TodoTelescope theme=dropdown<cr>')

require('laytan.session')

require('lualine').setup({
  options = { theme = 'catppuccin' },
  sections = {
    lualine_x = {
      -- {
      --   require('lazy.status').updates,
      --   cond = require('lazy.status').has_updates,
      --   color = { fg = '#ff9e64' },
      -- },
      'filetype',
    },
    lualine_y = { require('laytan.lualine.search'), 'progress' },
  },
  tabline = {
    lualine_c = { require('laytan.lualine.harpoon') },
    lualine_z = { { 'tabs', mode = 2 } },
  },
})


require('laytan.quick_command').setup()
require('laytan.lsp_focus').setup()
require('laytan.keymaps')
require('laytan.autocommands')

vim.filetype.add({
  pattern = {
    ['.*%.blade%.php'] = 'blade',
    ['.*%.neon']       = 'yaml',
    ['.*%.sfc']        = 'php',
  },
})
