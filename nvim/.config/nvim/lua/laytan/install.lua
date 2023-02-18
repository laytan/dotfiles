-- Check if lazy.nvim is installed, install if not.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.notify(
    'Pulling the "lazy.nvim" plugin manager into "' .. lazypath .. '"',
    vim.log.levels.INFO
  )

  vim.fn.system(
    {
      'git',
      'clone',
      '--filter=blob:none',
      '--single-branch',
      'https://github.com/folke/lazy.nvim.git',
      lazypath,
    }
  )
end
vim.opt.runtimepath:prepend(lazypath)
