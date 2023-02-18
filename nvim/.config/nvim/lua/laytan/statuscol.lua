---@diagnostic disable: lowercase-global
-- Gets the non-gitsigns highlight for this line.
function get_ln_others()
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.v.lnum

  local cur_sign = vim.fn.sign_getplaced(bufnr, { group = '*', lnum = lnum })

  if cur_sign == nil then
    return nil
  end

  cur_sign = cur_sign[1]

  if cur_sign == nil then
    return nil
  end

  cur_sign = cur_sign.signs

  local cur_sign_no_git = {}
  for _, sign in ipairs(cur_sign) do
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

-- Gets the gitsigns highlight for this line.
function get_ln_gitsign()
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.v.lnum

  local cur_sign = vim.fn.sign_getplaced(
    bufnr, { group = 'gitsigns_vimfn_signs_', lnum = lnum }
  )

  if cur_sign == nil then
    return nil
  end

  cur_sign = cur_sign[1]

  if cur_sign == nil then
    return nil
  end

  cur_sign = cur_sign.signs

  if cur_sign == nil then
    return nil
  end

  cur_sign = cur_sign[1]

  if cur_sign == nil then
    return nil
  end

  return cur_sign['name']
end

-- Creates and returns the gitsigns bar.
function gitsign_bar()
  local hl = get_ln_gitsign() or 'NonText'
  local bar = ' ▏'

  return table.concat({ '%#', hl, '#', bar })
end

-- Creates and returns the number bar.
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

vim.opt.statuscolumn = '%=%{%v:lua.num_bar()%} %{%v:lua.gitsign_bar()%}'
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
