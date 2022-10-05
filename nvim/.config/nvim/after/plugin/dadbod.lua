vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_use_nerd_fonts = 1

local group = vim.api.nvim_create_augroup('dadboddie', {})

-- Set cmdheight to 1 because it otherwise asks for confirmation every time
-- dbui tries to execute a query.
vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  callback = function(data)
    vim.schedule(function()
      if vim.bo.filetype == 'dbui' or vim.bo.filetype == 'mysql' then
        vim.o.cmdheight = 1
      else
        vim.o.cmdheight = 0
      end
    end)
  end,
})
