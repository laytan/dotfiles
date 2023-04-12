-- Command line autocompletion.
return {
  'gelguy/wilder.nvim',
  dependencies = { 'romgrk/fzy-lua-native' },
  event = 'CmdlineEnter',
  config = function()
    local wilder = require('wilder')
    wilder.setup({ modes = { ':', '/', '?' } })
    wilder.set_option('use_python_remote_plugin', 0)
    wilder.set_option(
      'pipeline', {
        wilder.branch(
          wilder.cmdline_pipeline(
            { fuzzy = 2, fuzzy_filter = wilder.lua_fzy_filter() }
          ), wilder.vim_search_pipeline()
        ),
      }
    )

    local search_renderer = wilder.wildmenu_renderer(
      {
        highlighter = wilder.basic_highlighter(),
        highlights = { ['accent'] = 'lualine_a_inactive' },
        right = { ' ', wilder.wildmenu_index() },
      }
    )

    wilder.set_option(
      'renderer', wilder.renderer_mux(
        {
          [':'] = wilder.wildmenu_renderer(
            {
              highlighter = wilder.lua_fzy_highlighter(),
              highlights = { ['accent'] = 'lualine_a_inactive' },
            }
          ),
          ['/'] = search_renderer,
          ['?'] = search_renderer,
        }
      )
    )
  end,
}
