local ts_utils = require('laytan.treesitter')
local ls = require('luasnip')
local events = require('luasnip.util.events')
local s = ls.s
local sn = ls.snippet_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local t = ls.text_node
local fmt = require('luasnip.extras.fmt').fmt

local default_ret_assignments = sn(nil, t({ 'if err' }))
local ret_assignments_cache = default_ret_assignments
local ret_assignments_short = true
local function ret_assignments(typing)
  local result = nil
  local done = false

  local pos = vim.lsp.util.make_position_params()

  -- signatureHelp works when you are in the () of the function call.
  -- but if the last character of the function call we typed is ),
  -- the function call hasn't been "complete" yet, now, if the end is ),
  -- we can decrease the pos by 1, putting us in front of the ) which
  -- should help the signatureHelp complete more often.
  if typing[1][1]:sub(-1, -1) == ')' then
    pos.position.character = pos.position.character - 1
  end

  vim.lsp.buf_request(
    0, 'textDocument/signatureHelp', pos, function(_, r, _, _)
      done = true
      result = r
    end
  )

  -- Wait, because we can't use callbacks with LuaSnip.
  vim.wait(
    1000, function()
      return done
    end, 10
  )

  -- If no result from LSP, return the previously cached result.
  if not (result and result['signatures'] and result['signatures'][1] and
    result['signatures'][1]['label']) then
    return ret_assignments_cache
  end

  local res = result['signatures'][1]['label']

  -- Following mods parse out the return type, either "(bool, err)" or
  -- just "error", or "(b bool, err error)".
  -- The parenthesis are then removed and it is split on the commas.
  local parts = vim.fn.split(res, ')')
  local ret_part = parts[#parts]:sub(2, -1)
  if ret_part:sub(1, 1) == '(' then
    ret_part = ret_part:sub(2, -1)
  end
  if ret_part:sub(#ret_part, -1) == ')' then
    ret_part = ret_part:sub(1, -2)
  end
  local rets = vim.fn.split(ret_part, ', ')

  -- For each of the return types, join them on a comma,
  -- if the ret type is named, use that. Otherwise res, res1, res2 etc.
  res = {}
  for ind, ret in ipairs(rets) do
    local ps = vim.fn.split(ret, ' ')
    local name = ps[1]

    -- Generate res, res1 etc. if not named return.
    if #ps == 1 then
      name = 'res'
      if ind > 1 then
        name = name .. ind
      end
      -- Last return is err if not named.
      if ind == #rets then
        name = 'err'
      end
    end

    table.insert(res, i(ind, { name }))

    if ind ~= #rets then
      table.insert(res, t({ ', ' }))
    end
  end

  if #res == 1 then
    res = t({ 'if err' })
  end

  ret_assignments_cache = sn(nil, res)
  ret_assignments_short = #res <= 1
  return ret_assignments_cache
end

-- Query to resolve the result of a function,
-- this is "(types...)" or (if only one return) the type directly.
vim.treesitter.query.set_query(
  'go', 'LuaSnip_Result_Function', [[ [
    (function_declaration result: (_) @result)
  ] ]]
)

-- Map from type to their default values, not here == "nil".
local default_values = {
  bool = 'false',
  int = '0',
  int8 = '0',
  int16 = '0',
  int32 = '0',
  int64 = '0',
  uint = '0',
  uint8 = '0',
  uint16 = '0',
  uint32 = '0',
  uint64 = '0',
  string = '""',
  float = '0.0',
  float64 = '0.0',
}

local function outer_returns()
  -- Go up using the result query defined above.
  local query = vim.treesitter.query.get_query('go', 'LuaSnip_Result_Function')
  for _, node in ts_utils.iter_captures_up(query) do
    local text = ts_utils.get_node_text(node)
    if text == nil then
      return
    end

    -- Remove () if there.
    if text:sub(1, 1) == '(' then
      text = text:sub(2, -2)
    end

    local res = ''

    ---@diagnostic disable-next-line: param-type-mismatch
    local rets = vim.fn.split(text, ', ')
    -- Remove last, that is the err.
    table.remove(rets, #rets)

    -- Concatenate the default values for the types.
    for _, ret in ipairs(rets) do
      local ps = vim.fn.split(ret, ' ')
      local type = ps[#ps]
      res = res .. (default_values[type] or 'nil') .. ', '
    end

    return res
  end
end

local function short_err_check()
  if ret_assignments_short then
    return '; err != nil {'
  end

  return ''
end

local function long_err_check()
  if ret_assignments_short then
    return ''
  end

  return { '', 'if err != nil {' }
end

return {
  s(
    { trig = '?', name = 'Expand err handling' }, fmt(
      [[
{} := {}{}{}
  return {}fmt.Errorf("{}: %w", {}err)
}}
{}
]], {
        d(4, ret_assignments, { 1 }),
        i(1),
        f(short_err_check, { 1 }),
        f(long_err_check, { 1 }),
        f(outer_returns),
        i(2),
        i(3),
        i(0),
      }
    ), {
      callbacks = {
        [-1] = {
          [events.pre_expand] = function()
            ret_assignments_cache = default_ret_assignments
            ret_assignments_short = true
          end,
        },
      },
    }
  ),
}
