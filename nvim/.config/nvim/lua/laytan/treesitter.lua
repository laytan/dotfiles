local ts_utils = require('nvim-treesitter.ts_utils')

local M = {}

M.get_node_text = function(node)
  return vim.treesitter.get_node_text(node, 0)
end

M.iter_captures_up = function(query)
  local curr_row = vim.api.nvim_win_get_cursor(0)[1]
  return M.iter_captures(query, 0, curr_row)
end

M.iter_captures_down = function(query)
  local curr_row = vim.api.nvim_win_get_cursor(0)[2]
  return M.iter_captures(query, curr_row, 0)
end

M.iter_captures = function(query, start_row, end_row)
  local curr_node = ts_utils.get_node_at_cursor()
  if not curr_node then
    return nil
  end

  local root = ts_utils.get_root_for_node(curr_node)
  return query:iter_captures(root, 0, start_row, end_row)
end

return M
