-- Telescope and color comments.
return {
  'folke/todo-comments.nvim',
  event = 'BufEnter',
  keys = { { '<leader>td', ':silent :TodoTelescope theme=dropdown<cr>' } },
  -- Most of this setup is so the format of PHP/PHPCS is accepted.
  -- That is: "@todo this needs to be done."
  -- FIX: a
  -- FIXME: b
  -- BUG: c
  -- FIXIT: d
  -- ISSUE: e
  -- TODO: a
  -- @todo: b
  -- NOTE: a
  -- HACK: a
  -- WARN: b
  -- WARNING: c
  -- XXX: d
  -- PERF: a
  -- OPTIM: b
  opts = {
    highlight = { pattern = [[.*<(KEYWORDS)\s*]] },
    search = { pattern = [[\b(KEYWORDS)\b]] },
    keywords = { TODO = { alt = { 'todo' } } },
  },
}
