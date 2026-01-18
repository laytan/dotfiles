local vim_highlight = require('vim.hl')

local function open_image()
  local opener
  if vim.fn.has("win32") == 1 then
    opener = "start"
  elseif vim.fn.has("macunix") == 1 then
    opener = "open"
  else
    opener = "xdg-open"
  end

  local current_file = vim.api.nvim_buf_get_name(0)
  vim.fn.jobstart({ opener, current_file }, { detach = true })
  vim.cmd('buffer #')
end

local group = vim.api.nvim_create_augroup('laytan_general', {})

vim.api.nvim_create_autocmd(
  {'BufNewFile', 'BufRead'},
  {
    group = group,
    pattern = { '*.jpg', '*.jpeg', '*.png' },
    callback = open_image,
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
