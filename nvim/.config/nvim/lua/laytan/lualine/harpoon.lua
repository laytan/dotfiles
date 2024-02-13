local function basename(path)
  local last_slash_at = path:find('/[^/]*$')
  if last_slash_at == nil then
    return path
  end

  return path:sub(last_slash_at + 1)
end

-- Show harpoon marks.
local harpoon = require('harpoon')
local mark_keys = { 'j', 'k', 'l', ';' }

return function()
  local output = {}

  local current = harpoon:list().config:create_list_item()

  for i, key in ipairs(mark_keys) do
    local item = harpoon:list():get(i)
    if item == nil then
      goto continue
    end

    local filename = basename(item.value)

    local label = ' ' .. key .. ' ' .. filename .. ' '

    local is_open = harpoon:list().config.equals(item, current)
    if is_open then
      table.insert(output, '%#lualine_a_normal#' .. label)
    else
      table.insert(output, '%#lualine_a_inactive#' .. label)
    end

    ::continue::
  end

  return table.concat(output, '')
end
