-- Databases.
return {
  'tpope/vim-dadbod',
  dependencies = { 'kristijanhusak/vim-dadbod-ui' },
  -- CmdlineEnter so we get auto-complete for the commands.
  event = 'CmdlineEnter',
  config = function()
    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.g.db_ui_use_nerd_fonts = 1
  end,
}
