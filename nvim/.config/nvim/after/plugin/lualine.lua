local function basename(path)
  local last_slash_at = path:find('/[^/]*$')
  if last_slash_at == nil then
    return path
  end

  return path:sub(last_slash_at + 1)
end

-- Show harpoon marks.
local harpoon = require('harpoon')
local harpoon_mark = require('harpoon.mark')
local mark_keys = { 'j', 'k', 'l', ';' }
local marks = function()
  local marks = harpoon.get_mark_config().marks
  local current_mark_idx = harpoon_mark.get_current_index()
  local output = {}

  for i, key in ipairs(mark_keys) do
    if marks[i] == nil then
      goto continue
    end

    local filename = basename(marks[i].filename)

    local label = ' ' .. key .. ' ' .. filename .. ' '

    if i == current_mark_idx then
      table.insert(output, '%#lualine_a_normal#' .. label)
    else
      table.insert(output, '%#lualine_a_inactive#' .. label)
    end

    ::continue::
  end

  return table.concat(output, '')
end

require('lualine').setup(
  {
    options = { theme = 'catppuccin' },
    sections = { lualine_x = { 'overseer', 'filetype' } },
    tabline = { lualine_c = { marks }, lualine_z = { { 'tabs', mode = 2 } } },
  }
)
