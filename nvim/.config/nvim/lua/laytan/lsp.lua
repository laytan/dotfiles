local util = require('lspconfig.util')

local higroup = vim.api.nvim_create_augroup('hilspiepie', {})

local M = {}

M.config = function(_config, on_attach)
  local dec_on_attach = function(client, bufnr)
    -- todo removable?
    -- If the LSP client supports highlighting, set it up.
    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd(
        { 'CursorHold', 'CursorHoldI' }, {
          group = higroup,
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        }
      )

      vim.api.nvim_create_autocmd(
        'CursorMoved', {
          group = higroup,
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        }
      )
    end

    if on_attach ~= nil then
      on_attach(client, bufnr)
    end
  end

  return vim.tbl_deep_extend(
    'keep', {
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      on_attach = dec_on_attach,
    }, _config or {}
  )
end

-- Makes Drupal modules have the base Drupal site as their root dir.
-- Makes cakephp plugins have the base cake app as their root dir.
M.php_root_dirs = function(fname)
  local is_drupal_module = util.root_pattern('modules')(fname) ~= nil
  local is_plugin = util.root_pattern('plugins')(fname) ~= nil
  local is_wordpress = util.root_pattern('wp-content')(fname) ~= nil
  local is_cake_plugin = is_plugin and not is_wordpress

  if is_wordpress then
    return util.root_pattern('wp-content')(fname)
  end

  if is_drupal_module then
    return util.root_pattern('web')(fname)
  end

  if is_cake_plugin then
    return util.root_pattern('plugins')(fname)
  end

  return util.root_pattern('composer.json')(fname) or
           util.root_pattern('.git')(fname)
end

return M
