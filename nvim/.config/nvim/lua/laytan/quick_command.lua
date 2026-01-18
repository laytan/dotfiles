local Job = require('plenary.job')

-- Changes ANSI colors to vim highlighting.
local baleia = require('baleia').setup({})

local M = {}

M.current_command = ''
M.running_job = nil
M.display = {
  buf = nil,
  win = nil,
}
M.on_save = false

M.setup = function()
  vim.keymap.set('n', '<F4>', M.change_request)
  vim.keymap.set('n', '<F5>', M.run)
  vim.keymap.set('n', '<C-q>', M.abort)

  vim.api.nvim_create_user_command('QCChange', M.change_request, {})
  vim.api.nvim_create_user_command('QCToggleOnSave', M.toggle_on_save, {})
end

M.toggle_on_save = function()
  if M.on_save then
    vim.api.nvim_del_augroup_by_name('quick_command')
    vim.notify('Quick command no longer running on save', vim.log.levels.INFO)
  else
    local augroup = vim.api.nvim_create_augroup('quick_command', {})
    vim.api.nvim_create_autocmd('BufWritePost', {
        group = augroup,
        callback = M.run,
    })
    vim.notify('Quick command now running on save', vim.log.levels.INFO)
  end

  M.on_save = not M.on_save
end

M.change_request = function(callback)
    vim.ui.input({
        prompt = 'Enter quick command: ',
        completion = 'shellcmd',
        default = M.current_command or '',
    }, function(input)
        M.change(input)
        if callback ~= nil then callback() end
    end)
end

M.change = function(input)
  if input == nil or input == '' then
    vim.notify('Not changing quick command, got empty input', vim.log.levels.INFO)
    return
  end

  M.current_command = input
end

M.run = function()
  if M.current_command == nil or M.current_command == '' then
    M.change_request(M.run)
    return
  end

  if M.running_job ~= nil then
    M.abort()
  end

  if M.display.buf ~= nil or M.display.win ~= nil then
    M.close()
  end

  local function split_args(input)
      local args = {}
      local in_quote = false
      local current_arg = ""
      local escape_next = false

      for i = 1, #input do
          local char = input:sub(i, i)

          if escape_next then
              current_arg = current_arg .. char
              escape_next = false
          elseif char == "\\" then
              escape_next = true
          elseif char == '"' then
              in_quote = not in_quote
          elseif char == " " and not in_quote then
              if #current_arg > 0 then
                  table.insert(args, current_arg)
                  current_arg = ""
              end
          else
              current_arg = current_arg .. char
          end
      end

      if #current_arg > 0 then
          table.insert(args, current_arg)
      end

      return args
  end

  local parts = split_args(M.current_command)

  M.running_job = Job:new({
    command = parts[1],
    args = { unpack(parts, 2) },
    on_stdout = M.on_stdout,
    on_stderr = M.on_stderr,
    on_exit = M.on_exit,
  })
  M.running_job:start()
  M.open()
end

M.on_stdout = vim.schedule_wrap(function(error, data)
  if M.display.buf == nil then return end

  if error ~= nil and error ~= '' then
    vim.notify(error, vim.lsp.log_levels.ERROR)
  end

  if data == nil then return end

  M.append({data})
end)

M.on_stderr = vim.schedule_wrap(function(error, data)
  if M.display.buf == nil then return end

  if error ~= nil and error ~= '' then
    vim.notify(error, vim.lsp.log_levels.ERROR)
  end

  if data == nil then return end

  M.append({'\x1b[91m' .. data .. '\x1b[0m'})
end)

M.on_exit = vim.schedule_wrap(function(_, code, signal)
  M.running_job = nil
  if M.display.buf == nil then return end

  code = code or 0
  signal = signal or 1

  M.append({'', 'command exited with exit code ' .. code .. ' and signal ' .. signal, ''})
end)

M.append = function(lines)
  if M.display.buf == nil then return end

  local win_width = vim.api.nvim_win_get_width(M.display.win)

  local padded_lines = {}

  local max = 0
  for _, line in pairs(lines) do
    max = math.max(max, line:len() + 2)
    table.insert(padded_lines, ' ' .. line .. ' ')
  end

  if max > win_width and max < (vim.api.nvim_get_option_value('columns', { scope = 'global' }) - 5) then
    vim.api.nvim_win_set_width(M.display.win, max)
  end

  vim.api.nvim_win_set_height(M.display.win, vim.api.nvim_win_get_height(M.display.win) + #padded_lines)

  vim.api.nvim_set_option_value('modifiable', true, { buf = M.display.buf })
  baleia.buf_set_lines(M.display.buf, -1, -1, false, padded_lines)
  vim.api.nvim_set_option_value('modifiable', false, { buf = M.display.buf })
end

M.abort = function()
  if M.running_job ~= nil then
    M.running_job:shutdown()
    M.running_job = nil
  else
    M.close()
  end
end

M.open = function()
  local width = vim.api.nvim_get_option_value('columns', { scope = 'global' })

  local win_width = math.ceil(width * 0.3)

  local row = 2
  local col = width - win_width -1

  M.display.buf = vim.api.nvim_create_buf(false, true)
  M.display.win = vim.api.nvim_open_win(M.display.buf, false, {
      relative = 'editor',
      width = win_width,
      height = 1,
      row = row,
      col = col,
      style = 'minimal',
  })
  vim.api.nvim_buf_set_keymap(M.display.buf, 'n', 'q', ':silent lua require("laytan.quick_command").abort()<cr>', {})
  vim.api.nvim_set_option_value('modifiable', false, { buf = M.display.buf })
end

M.close = function()
  if M.display.win ~= nil then
    pcall(vim.api.nvim_win_close, M.display.win, true)
    M.display.win = nil
  end

  if M.display.buf ~= nil then
    pcall(vim.api.nvim_buf_delete, M.display.buf, { force = true })
    M.display.buf = nil
  end
end

return M
