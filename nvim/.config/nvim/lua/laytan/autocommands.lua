local vim_highlight = require('vim.highlight')

-- TODO: convert to lua, support linux
local function openImage()
  vim.api.nvim_exec2(
    [[
      fu! StartsWith(longer, shorter) abort
          if a:shorter == ''
              return 1
          endif

          return a:longer[0:len(a:shorter)-1] ==# a:shorter
      endfunction

      let b:prevBuffer = bufname(winbufnr(winnr('#')))

      :silent exec '!open "%"'

       if StartsWith(b:prevBuffer, 'NvimTree')
           :q
           return
       endif

       exec "normal! \<c-^>"
    ]]
  )
end

local group = vim.api.nvim_create_augroup('laytan_general', {})

vim.api.nvim_create_autocmd(
  'BufEnter',
  { group = group, pattern = '*.neon', command = 'setlocal filetype=yaml' }
)

vim.api.nvim_create_autocmd(
  'BufEnter',
  { group = group, pattern = '*.sfc', command = 'setlocal filetype=php' }
)

vim.api.nvim_create_autocmd(
  'BufEnter', {
    group = group,
    pattern = { '*.jpg', '*.jpeg', '*.png' },
    callback = openImage,
  }
)

vim.api.nvim_create_autocmd(
  'TextYankPost', {
    group = group,
    callback = function()
      vim_highlight.on_yank(
        { higroup = 'Search', timeout = 100, on_visual = false }
      )
    end,
  }
)
