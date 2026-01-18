require('telescope-all-recent').setup({})

local telescope = require('telescope')
local builtin = require('telescope.builtin')
local themes = require('telescope.themes')
local actions = require('telescope.actions')
local lga_actions = require('telescope-live-grep-args.actions')

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
      live_grep_args = {
        auto_quoting = true,
        mappings = {
          i = {
            ['<C-k>'] = lga_actions.quote_prompt(),
            ['<C-i>'] = lga_actions.quote_prompt({ postfix = ' --iglob' }),
          },
        },
      },
    },
    defaults = {
      mappings = {
        n = {
          ['<C-j>'] = actions.cycle_history_next,
          ['<C-k>'] = actions.cycle_history_prev,
        },
      },
    },
  }
)

telescope.load_extension('fzf')
telescope.load_extension('ui-select')
telescope.load_extension('live_grep_args')

vim.keymap.set(
  'n', '<leader>ps', function()
    telescope.extensions.live_grep_args.live_grep_args(theme())
  end
)

vim.keymap.set(
  'n', '<leader>fps', function()
    telescope.extensions.live_grep_args.live_grep_args(theme({
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
    }))
  end
)

vim.keymap.set(
  'n', '<leader>tr', function()
    builtin.resume(theme())
  end
)

vim.keymap.set(
  'n', '<leader>tt', function()
    builtin.diagnostics(theme())
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

-- TODO: doesn't work with symlink
local odin_path = vim.fn.exepath("odin")
if odin_path ~= "" then
  local odin_root = vim.fs.dirname(odin_path)
  vim.keymap.set('n', '<leader>fof', function()
    builtin.find_files(theme({ cwd = odin_root, prompt_title = "Find Odin Files" }))
  end)

  vim.keymap.set('n', '<leader>os', function()
    builtin.live_grep(theme({ cwd = odin_root, prompt_title = "Grep Odin Files" }))
  end)
end

vim.keymap.set(
  'n', '<leader>?', function()
    builtin.help_tags(theme())
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
