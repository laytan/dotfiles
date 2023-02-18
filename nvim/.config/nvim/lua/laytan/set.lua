vim.g.mapleader = ' '
vim.g.cursorhold_updatetime = 500

vim.opt.encoding = 'UTF-8'

vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.relativenumber = true
vim.opt.nu = true

vim.opt.hlsearch = false

vim.opt.hidden = true

vim.opt.errorbells = false

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.incsearch = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 8

vim.opt.signcolumn = 'yes'

vim.opt.clipboard = 'unnamedplus'

vim.opt.ts = 4

vim.opt.mouse = ''

vim.opt.termguicolors = true

vim.opt.spell = true
vim.opt.spelloptions = 'camel,noplainbuffer'

vim.opt.cmdheight = 0
vim.opt.laststatus = 3

vim.opt.shortmess:append('s')

function get_ln_others()
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.v.lnum

  local cur_sign = vim.fn.sign_getplaced(bufnr, { group = '*', lnum = lnum })

  if (cur_sign == nil) then
    return nil
  end

  cur_sign = cur_sign[1]

  if (cur_sign == nil) then
    return nil
  end

  cur_sign = cur_sign.signs

  cur_sign_no_git = {}
  for index, sign in ipairs(cur_sign) do
    if not (sign['group'] or ''):find('^gitsigns_vimfn_signs_') then
      table.insert(cur_sign_no_git, sign)
    end
  end

  cur_sign = cur_sign_no_git[1]
  if cur_sign == nil then
    return nil
  end

  return cur_sign['name']
end

function get_ln_gitsign()
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.v.lnum

  local cur_sign = vim.fn.sign_getplaced(
    bufnr, { group = 'gitsigns_vimfn_signs_', lnum = lnum }
  )

  if (cur_sign == nil) then
    return nil
  end

  cur_sign = cur_sign[1]

  if (cur_sign == nil) then
    return nil
  end

  cur_sign = cur_sign.signs

  if (cur_sign == nil) then
    return nil
  end

  cur_sign = cur_sign[1]

  if (cur_sign == nil) then
    return nil
  end

  return cur_sign['name']
end

function gitsign_bar()
  local hl = get_ln_gitsign() or 'NonText'
  local bar = ' ▏'

  return table.concat({ '%#', hl, '#', bar })
end

function num_bar()
  local hl = get_ln_others()
  local ln = vim.v.relnum
  local is_curr_line = ln == 0
  if is_curr_line then
    ln = vim.v.lnum
  end

  if is_curr_line or hl == nil then
    return ln
  else
    return table.concat({ '%#', hl, '#', ln })
  end
end

vim.opt.splitkeep = 'screen'
vim.opt.statuscolumn = '%=%{%v:lua.num_bar()%} %{%v:lua.gitsign_bar()%}'
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
