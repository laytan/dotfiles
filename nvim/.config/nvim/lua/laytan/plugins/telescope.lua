-- Telescope.
return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-telescope/telescope-ui-select.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    {
      'prochri/telescope-all-recent.nvim',
      dependencies = { 'kkharji/sqlite.lua' },
      config = true,
    },
    'jedrzejboczar/possession.nvim',
  },
  -- NOTE: telescope handles vim.ui.select, I did not find a way to have it
  -- lazy load when that is called, so this seems the best we can do.
  event = 'VeryLazy',
  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')
    local themes = require('telescope.themes')
    local actions = require('telescope.actions')

    local theme = function(opts)
      opts = opts or {}
      return vim.tbl_deep_extend(
        'force', themes.get_dropdown(
          {
            layout_strategy = 'center',
            layout_config = {
              width = function(_, max_columns, _)
                return max_columns - 10
              end,
              anchor = 'S',
            },
            prompt_prefix = '   ',
            selection_caret = '  ',
            entry_prefix = '  ',
            winblend = 5,
          }
        ), opts
      )
    end
    telescope.setup(
      {
        extensions = {
          ['ui-select'] = { theme() },
        },
        defaults = {
          mappings = {
            i = {
              ['<C-j>'] = actions.cycle_history_next,
              ['<C-k>'] = actions.cycle_history_prev,
            },
          },
        },
      }
    )

    telescope.load_extension('fzf')
    telescope.load_extension('ui-select')
    telescope.load_extension('possession')

    vim.keymap.set(
      'n', '<leader>ps', function()
        builtin.live_grep(theme())
      end
    )

    vim.keymap.set(
      'n', '<leader>fps', function()
        builtin.live_grep(
          theme(
            {
              vimgrep_arguments = {
                'rg',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
                '-uu',
                '--glob',
                '!.git/*',
              },
            }
          )
        )
      end
    )

    vim.keymap.set(
      'n', '<leader>tr', function()
        builtin.resume(theme())
      end
    )

    vim.keymap.set(
      'n', '<leader>ff', function()
        builtin.find_files(theme())
      end
    )

    vim.keymap.set(
      'n', '<leader>fa', function()
        builtin.find_files(theme({ hidden = true, no_ignore = true }))
      end
    )

    vim.keymap.set(
      'n', '<leader>?', function()
        builtin.help_tags(theme())
      end
    )

    vim.keymap.set(
      'n', '<leader>ob', function()
        builtin.buffers(theme())
      end
    )

    local main = '#24273a'
    local text = '#cad3f5'
    local subtext = '#a5adcb'
    local TelescopePrompt = {
      TelescopeNormal = { bg = main },
      TelescopeBorder = { bg = main, fg = main },
      TelescopeTitle = { fg = text },
      TelescopePromptTitle = { fg = subtext },
      TelescopePromptCounter = { fg = subtext },
      TelescopePreviewTitle = { fg = main, bg = main },
      TelescopeResultsTitle = { fg = main, bg = main },
    }

    for hl, col in pairs(TelescopePrompt) do
      vim.api.nvim_set_hl(0, hl, col)
    end
  end,
}
