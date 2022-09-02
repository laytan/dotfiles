-- Pipes the `bin/cake routes` command into telescope.
--
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local utils = require('telescope.utils')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local M = {}

local default_config = { cmd = { 'bin/cake', 'routes' }, cache = false }
local config = {}
local cached_routes = {}

M.setup = function(overrides)
  overrides = overrides or {}
  config = vim.tbl_deep_extend('keep', overrides, default_config)
end

M.is_empty = function(value)
  return value == vim.NIL or value == nil or value == ''
end

M.exec_command = function(config_cmd)
  -- Need to copy cmd, get_os_command_output mutates it.
  local cmd = vim.tbl_deep_extend('keep', {}, config_cmd)
  local stdout, ret, stderr = utils.get_os_command_output(cmd, vim.fn.getcwd())
  if ret == 1 then
    vim.notify(
      string.format('[cakeroutes] %s', vim.inspect(stderr)),
      --- @diagnostic disable-next-line: redundant-parameter
      vim.log.levels.ERROR
    )
    return
  end

  return stdout
end

M.lines = function(multiline_string)
  local lines = {}
  for _, line in pairs(multiline_string) do
    table.insert(lines, line)
  end

  return lines
end

M.parse_cake_route_line = function(line)
  local values = {}
  for value in string.gmatch(line, '[^|%s]+') do
    table.insert(values, value)
  end

  local metadata = vim.json.decode(values[3])

  local methods = metadata._method or {}
  if type(methods) == 'string' then
    methods = { methods }
  end

  if M.is_empty(metadata.controller) or M.is_empty(metadata.action) then
    return
  end

  local filename = string.format(
    'plugins/%s/src/Controller/%sController.php', metadata.plugin,
    metadata.controller
  )
  if M.is_empty(metadata.plugin) then
    filename = string.format(
      'src/Controller/%sController.php', metadata.controller
    )
  end

  return {
    raw = line,
    id = vim.trim(values[1]),
    url = vim.trim(values[2]),
    controller = metadata.controller,
    plugin = metadata.plugin,
    action = metadata.action,
    methods = methods,
    label = vim.trim(
      string.format(
        '%s %s', table.concat(methods, '|'), values[2]
      )
    ),
    filename = vim.trim(filename),
  }
end

M.remove_table_markup_lines = function(lines)
  table.remove(lines, 1)
  table.remove(lines, 1)
  table.remove(lines, 1)
  table.remove(lines, #lines)
  table.remove(lines, #lines)

  return lines
end

M.routes = function()
  if config.cache and #cached_routes > 0 then
    return cached_routes
  end

  local stdout = M.exec_command(config.cmd)
  if stdout == nil then
    return {}
  end

  local lines = M.lines(stdout)
  lines = M.remove_table_markup_lines(lines)

  local results = {}
  for _, line in pairs(lines) do
    local result = M.parse_cake_route_line(line)
    if not M.is_empty(result) then
      table.insert(results, result)
    end
  end

  cached_routes = results
  return results
end

M.picker = function(opts)
  opts = opts or {}

  local results = M.routes()
  if #results == 0 then
    return
  end

  pickers.new(
    opts, {
      prompt_title = 'CakePHP Routes',
      finder = finders.new_table {
        results = results,
        entry_maker = function(entry)
          return { value = entry, display = entry.label, ordinal = entry.label }
        end,
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(
          function()
            actions.close(prompt_bufnr)
            local entry = action_state.get_selected_entry().value

            -- print(vim.inspect(entry))

            --- Opens the file and searches for the action function.
            vim.api.nvim_command(string.format(':e %s', entry.filename))
            vim.api.nvim_command(string.format('/function %s', entry.action))
          end
        )
        return true
      end,
    }
  ):find()
end

return M
