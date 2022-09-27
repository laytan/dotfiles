-- Show search status in lualine.
-- Only when actually using the search.
local is_searching = false

local group = vim.api.nvim_create_augroup('ll_lualine_search', {})

vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = group,
  callback = function(arg)
    if arg.match == "/" or arg.match == "?" then
      is_searching = true
    end
  end,
})

vim.api.nvim_create_autocmd('InsertEnter', {
  group = group,
  callback = function()
    is_searching = false
  end
})

vim.keymap.set('n', 'n', function ()
  is_searching = true
  return "n"
end, { expr = true })

vim.keymap.set('n', 'N', function ()
  is_searching = true
  return "N"
end, { expr = true })

return function()
  if not is_searching then
    return ""
  else
    -- Get content of the "/ register, which holds the last search query.
    local search = vim.api.nvim_eval('@/')
    local count = vim.fn.searchcount()

    return search .. ': ' .. count['current'] .. '/' .. count['total']
  end
end

