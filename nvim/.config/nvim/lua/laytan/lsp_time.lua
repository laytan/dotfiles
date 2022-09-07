-- Very initial and quick & dirty creation to time lsp requests, lots of issues
-- with it.
--
-- - You can't call get_handlers for more than 1 lsp config at a time.
-- - You have to explicitly call signal_start when a request is started.
-- - etc.
local M = {}

M.timings = {}

vim.api.nvim_create_user_command(
  'LspTimeRaw', function(ctx)
    if ctx.fargs[1] ~= nil then
      if ctx.fargs[2] ~= nil then
        print(vim.inspect(M.timings[ctx.fargs[1]][ctx.fargs[2]]))
      else
        print(vim.inspect(M.timings[ctx.fargs[1]]))
      end
    else
      print(vim.inspect(M.timings))
    end
  end, { nargs = '*' }
)

vim.api.nvim_create_user_command(
  'LspTime', function()
    for action, timings in pairs(M.timings) do
      local count = #timings
      local total = 0

      for _, timing in ipairs(timings) do
        total = total + timing.duration
      end

      vim.notify(
        string.format(
          'Average %s response: %.3fms', action, total / count
        )
      )
    end
  end, {}
)

M.get_handlers = function(actions)
  local handlers = {}
  for action, handler in pairs(vim.lsp.handlers) do
    if actions[action] then
      handlers[action] = M._get_handler(action, handler)
    else
      handlers[action] = handler
    end
  end

  return handlers
end

M._get_handler = function(action, defaultHandler)
  M.timings[action] = {}

  return function(...)
    local result = defaultHandler(...)

    M.signal_end(action)

    return result
  end
end

M.signal_start = function(action)
  table.insert(M.timings[action], { start_time = os.clock() })
end

M.signal_end = function(action)
  local last_req = M.timings[action][#M.timings[action]]
  if last_req == nil then
    return
  end

  local start_time = last_req.start_time
  local duration = (os.clock() - start_time) * 1000

  last_req.duration = duration
end

return M
