local cmp_nvim_lsp = require('cmp_nvim_lsp')
local util = require('lspconfig.util')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local higroup = vim.api.nvim_create_augroup('hilspiepie', {})

local M = {}

M.config = function(_config, on_attach)
    local dec_on_attach = function(client, bufnr)
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
            capabilities = cmp_nvim_lsp.update_capabilities(
                vim.lsp.protocol.make_client_capabilities()
            ),
            on_attach = dec_on_attach,
        }, _config or {}
    )
end

-- Makes Drupal modules have the base Drupal site as their root dir.
-- Makes cakephp plugins have the base cake app as their root dir.
M.php_root_dirs = function(fname)
    local is_drupal_module = util.root_pattern('modules')(fname) ~= nil

    if is_drupal_module then
        return util.root_pattern('web')(fname)
    end

    return util.root_pattern('.git')(fname)
end

return M
