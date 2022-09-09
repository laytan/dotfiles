local download_packer = function()
  if vim.fn.input('Download Packer? (y for yes)') ~= 'y' then
    return
  end

  local directory = string.format(
    '%s/site/pack/packer/start/', vim.fn.stdpath('data')
  )

  vim.fn.mkdir(directory, 'p')

  local out = vim.fn.system(
    string.format(
      'git clone %s %s', 'https://github.com/wbthomason/packer.nvim',
      directory .. '/packer.nvim'
    )
  )

  print(out)
  print('Downloading packer.nvim...')
  print('( You\'ll need to restart now )')
end

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
}

local ts_install_configured = function()
  for _, value in ipairs(wanted_ts_parsers) do
    vim.cmd(':TSInstall ' .. value)
  end
end

local install_all = function()
  download_packer()
  ts_install_configured()
  vim.cmd(':GoInstallDeps')
  require('catppuccin').compile()
end

return function()
  vim.api.nvim_create_user_command(
    'TSInstallConfigured', ts_install_configured, {}
  )

  vim.api.nvim_create_user_command('InstallNvim', install_all, {})

  if not pcall(require, 'packer') then
    return true
  end

  return false
end
