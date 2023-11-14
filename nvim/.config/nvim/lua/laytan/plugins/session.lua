local function cwd_session()
  local p = require('possession')
  local cwd = vim.loop.cwd()
  if not cwd then
    return
  end

  for _, session in pairs(p.list()) do
    if session.cwd == cwd then
      return session
    end
  end
end

local function load_session()
  local p = require('possession')
  local session = cwd_session()
  if session == nil then
    vim.notify('No session matching cwd found', vim.log.levels.DEBUG)
    return
  end

  local ok, err = pcall(
    function()
      p.load(session.name)
    end
  )
  if not ok then
    vim.notify(
      'Could not load session "' .. session.name .. '": ' .. err,
      vim.log.levels.WARN
    )
    -- Recreate the session
    p.delete(session.name, { no_confirm = true })
    p.save(session.name)
  end
end

local function save_session()
  local p = require('possession')
  local session = cwd_session()
  if session == nil then
    return
  end

  p.save(session.name)
end

return {
  'jedrzejboczar/possession.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'rcarriga/nvim-notify',
    --[[ Need to have as dependency to work but isn't actually one --]] 'mfussenegger/nvim-dap',
  },
  keys = { { '<leader>sl', load_session }, { '<leader>ss', save_session } },
  lazy = false,
  config = function()
    vim.opt.sessionoptions = 'folds,help,tabpages,buffers'
    local p = require('possession')
    p.setup({ autosave = { current = true } })

    if vim.fn.argc() ~= 0 then
      return
    end
    load_session()
  end,
}
