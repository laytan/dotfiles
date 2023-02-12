local hover = require('hover')
local Job = require 'plenary.job'
local baleia = require('baleia').setup {}

local repo_pattern = '[^%s]+/[^%s]+'

vim.api.nvim_create_autocmd(
  'Syntax', {
    pattern = 'glow',
    callback = function(ctx)
      vim.schedule(
        function()
          vim.api.nvim_buf_set_option(ctx.buf, 'modifiable', true)
          baleia.once(ctx.buf)
          vim.api.nvim_buf_set_option(ctx.buf, 'modifiable', false)
        end
      )
    end,
  }
)

local function enabled()
  return vim.fn.expand('<cfile>'):match(repo_pattern) ~= nil
end

local function execute(done)
  local repo = vim.fn.expand('<cfile>'):match(repo_pattern)

  Job:new(
    {
      command = 'glow',
      args = {
        'github.com/' .. repo,
        '-s',
        'dark',
        '-w',
        vim.api.nvim_win_get_width(0),
      },
      on_exit = function(job)
        print(job:result())
        done { lines = job:result(), filetype = 'glow' }
      end,
    }
  ):start()
end

hover.register(
  { name = 'GitHub repos', priority = 1050, enabled = enabled,
    execute = execute }
)

