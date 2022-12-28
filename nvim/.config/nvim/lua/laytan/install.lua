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

-- Run :TSInstallConfigured to install the following parsers:
local wanted_ts_parsers = {
  'bash',
  'css',
  'dockerfile',
  'go',
  'gomod',
  'html',
  'javascript',
  'jsdoc',
  'json',
  'lua',
  'markdown',
  'php',
  'regex',
  'scss',
  'sql',
  'typescript',
  'vue',
  'yaml',
  'make',
  'python',
  'twig',
  'query',
  -- Terraform
  'hcl',
}

vim.api.nvim_create_user_command(
  'TSInstallConfigured', function()
    for _, value in ipairs(wanted_ts_parsers) do
      vim.cmd(':TSInstall ' .. value)
    end
  end, {}
)

vim.api.nvim_create_user_command(
  'InstallNvim', function()
    vim.cmd(':TSInstallConfigured')
    vim.cmd(':GoInstallDeps')
    require('catppuccin').compile()
  end, {}
)
