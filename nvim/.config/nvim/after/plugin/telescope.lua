local telescope = require('telescope')
local builtin = require('telescope.builtin')
local themes = require('telescope.themes')
local cursor_theme = themes.get_cursor()
local dropdown_theme = themes.get_dropdown()

telescope.setup(
  {
    extensions = {
      ['ui-select'] = { require('telescope.themes').get_dropdown({}) },
    },
  }
)
telescope.load_extension('fzf')
telescope.load_extension('ui-select')
telescope.load_extension('live_grep_args')

vim.keymap.set(
  'n', '<leader>d', function()
    builtin.lsp_definitions(cursor_theme)
  end
)
vim.keymap.set(
  'n', '<leader>i', function()
    builtin.lsp_implementation()
  end
)
vim.keymap.set(
  'n', '<leader>w', function()
    builtin.lsp_references(dropdown_theme)
  end
)

vim.keymap.set(
  'n', '<leader>ps', function()
    telescope.extensions.live_grep_args.live_grep_args(dropdown_theme)
  end
)
vim.keymap.set(
  'n', '<leader>fps', function()
    telescope.extensions.live_grep_args.live_grep_args(
      vim.tbl_extend(
        'keep', dropdown_theme, {
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '-u',
          },
        }
      )
    )
  end
)

vim.keymap.set(
  'n', '<leader>tr', function()
    builtin.resume()
  end
)

vim.keymap.set('n', '<leader>ff', ':Telescope find_files theme=dropdown<cr>')
vim.keymap.set(
  'n', '<leader>fa',
  ':Telescope find_files hidden=true no_ignore=true theme=dropdown<cr>'
)
vim.keymap.set('n', '<leader>?', ':Telescope help_tags theme=dropdown<cr>')

