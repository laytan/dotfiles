-- Completes Jira tickets using
-- https://github.com/ankitpokhrel/jira-cli
--
local Job = require("plenary.job")

local cmp_jira = { projects = { 'MCM', 'PRJ', 'IO', 'BMS' } }

local source = {}

local ends_with = function(str, ending)
  return ending == '' or str:sub(-#ending) == ending
end

source.new = function()
  local self = setmetatable({ cache = {} }, { __index = source })

  return self
end

source.complete = function(self, params, callback)
  local s = params.context.cursor_before_line
  if not s then
    callback({ items = {}, isIncomplete = true })
    return
  end

  -- s = text before the current cursor position
  local project = self._find_project(s)

  if project == nil then
    callback({ items = {}, isIncomplete = true })
    return
  end

  local is_cached = self.cache[project] ~= nil

  -- Return from cache, and after that, refresh the cache for instant response.
  if is_cached then
    callback({ items = self.cache[project], isIncomplete = false })
  end

  if vim.fn.executable('jira') ~= 1 then
    vim.notify('trying to complete Jira tickets, `jira` executable not found', vim.log.levels.WARN)
    callback({ items = {}, isIncomplete = false })
    return
  end

  Job:new(
    {
      command = 'jira',
      args = {
        'issue',
        'list',
        '--plain',
        '--no-headers',
        '--columns=key,type,summary,status,assignee',
        '--order-by=updated',
        '--paginate=100',
        '-p=' .. project,
      },

      on_exit = function(job)
        local result = job:result()

        local tickets = {}
        for _, item in ipairs(result) do
          -- replacing tabs with `;` for easier pattern matching
          local subbed = item:gsub('\t', ';')
          local _, _, key, ttype, summary, status, assignee = string.find(
            subbed, ('([^;]*);*'):rep(5, ';*')
          )
          table.insert(
            tickets, {
              label = key,
              documentation = {
                kind = 'markdown',
                value = '# ' .. summary .. '\n' .. ttype .. '\t' .. assignee ..
                  '\t' .. status,
              },
            }
          )
        end

        self.cache[project] = tickets
        if is_cached == false then
          callback({ items = tickets, isIncomplete = false })
        end
      end,
    }
  ):start()
end

source.get_trigger_characters = function()
  return { 'QWERTYUIOPASDFGHJKLZXCVBNM' }
end

source.is_available = function()
  return true
end

source._find_project = function(text)
  for _, project in ipairs(cmp_jira.projects) do
    if ends_with(text, project) then
      return project
    end
  end
  return nil
end

require('cmp').register_source('jira', source.new())

return cmp_jira
