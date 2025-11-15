local timeout = require('laytan.timeout')

local M = {}

M.focus_group = vim.api.nvim_create_augroup('lsp_focus_track', {})
M.focus_timeout = nil
M.lsp_stopped = false

M.setup = function()
  vim.api.nvim_create_autocmd('FocusLost', {
    group = M.focus_group,
    callback = M.on_focus_lost,
  })

  vim.api.nvim_create_autocmd('FocusGained', {
    group = M.focus_group,
    callback = M.on_focus_gained,
  })
end

M.on_focus_lost = function ()
  if M.focus_timeout ~= nil then
    return
  end

  M.focus_timeout = timeout.set(5 * 60 * 1000, vim.schedule_wrap(function()
    M.focus_timeout = nil
    vim.notify('Focus lost for 5 minutes, stopping LSP to free resources', vim.log.levels.INFO)
    vim.cmd(':LspStop')
    M.lsp_stopped = true
  end))
end

M.on_focus_gained = function()
  if M.focus_timeout ~= nil then
    timeout.clear(M.focus_timeout)
    M.focus_timeout = nil
  end

  if M.lsp_stopped then
    vim.notify(
      'Focus gained after LSP was stopped after inactivity, starting LSP again',
      vim.log.levels.INFO
    )
    pcall(vim.cmd, ':LspStart')
    -- vim.cmd(':LspStart')
    M.lsp_stopped = false
  end
end

return M
