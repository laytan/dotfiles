local function safe_cwd()
  local safe = vim.loop.cwd():lower():gsub("[%s%p]+", "_"):gsub("^_+", ""):gsub("_+$", "")
  return safe
end

local function cwd_session()
  local p = require('resession')
  local cwd = safe_cwd()
  for _, session in pairs(p.list()) do
    if session == cwd then
      return session
    end
  end
end

local function load_session()
  local p = require('resession')
  local session = cwd_session()
  if session == nil then
    vim.notify('No session matching cwd found', vim.log.levels.DEBUG)
    return
  end

  local ok, err = pcall(
    function()
      p.load(session)
    end
  )
  if not ok then
    vim.notify(
      'Could not load session "' .. session .. '": ' .. err,
      vim.log.levels.WARN
    )
    -- Recreate the session
    p.delete(session, { notify = false })
    p.save(session)
  end
end

local p = require('resession')
p.setup({
  autosave = { enabled = true, notify = false },
  extension = {
    quick_command = {},
  },
})

vim.keymap.set('n', '<leader>sl', load_session)
vim.keymap.set('n', '<leader>ss', function()
  local p = require('resession')
  p.save(safe_cwd())
end)

vim.api.nvim_create_autocmd('VimEnter', {
  nested = true,
  callback = function()
    if vim.fn.argc() == 0 then
      load_session()
    end
  end
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    local p = require('resession')
    local session = cwd_session()
    if session == nil then
      return
    end

    p.save(session)
  end,
})
