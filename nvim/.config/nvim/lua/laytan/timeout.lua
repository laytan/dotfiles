local M = {}

M.set = function(timeout, callback)
  local timer = vim.uv.new_timer()
  local function ontimeout()
    vim.uv.timer_stop(timer)
    vim.uv.close(timer)
    callback(timer)
  end
  vim.uv.timer_start(timer, timeout, 0, ontimeout)
  return timer
end

M.clear = function(timer)
  vim.uv.timer_stop(timer)
  vim.uv.close(timer)
end

return M
