-- nvim-cmp provides a completion menu.
--- @diagnostic disable: need-check-nil
return {
  'hrsh7th/nvim-cmp', -- Core completion functionality and menu.
  dependencies = {
    'hrsh7th/cmp-nvim-lsp', -- Provides LSP completions.
    'hrsh7th/cmp-buffer', -- Provides completions for symbols in the same buffer.
    'hrsh7th/cmp-path', -- Provides completions for paths on the system.
    { 'tzachar/cmp-tabnine', build = './install.sh' }, -- Provides completions using the Tabnine AI service.
    { 'saadparwaiz1/cmp_luasnip', dependencies = { 'L3MON4D3/LuaSnip' } }, -- Integrates snippet completion using LuaSnip.
    'onsails/lspkind.nvim', -- Used for nice icons in completion menu (class, function, package, etc.).
  },
  event = { 'InsertEnter' },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local lspkind = require('lspkind')
    local tabnine = require('cmp_tabnine.config')

    --- Removes vowels, prefixes an icon, colors it and used the first 3 characters only.
    --- @param kind string
    --- @return string
    local function transform_kind(kind)
      local icon = lspkind.presets.default[kind]
      local abbr = kind:gsub('[aeiou]', ''):sub(0, 3)
      return (icon or '') .. ' ' .. abbr
    end

    tabnine:setup({ show_prediction_strength = true })

    local source_mapping = {
      buffer = '[Buf]',
      nvim_lsp = '[Lsp]',
      cmp_tabnine = '[TN]',
      path = '[Path]',
      luasnips = '[Snip]',
    }

    cmp.setup(
      {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-n>'] = cmp.mapping.select_next_item(
            { behavior = cmp.SelectBehavior.Insert }
          ),
          ['<C-p>'] = cmp.mapping.select_prev_item(
            { behavior = cmp.SelectBehavior.Insert }
          ),
          ---@diagnostic disable-next-line: missing-parameter
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        },
        formatting = {
          format = function(entry, vim_item)
            local menu = source_mapping[entry.source.name]

            if entry.source.name == 'cmp_tabnine' then
              if entry.completion_item.data ~= nil and
                entry.completion_item.data.detail ~= nil then
                menu = entry.completion_item.data.detail .. ' ' .. menu
              end
            end

            vim_item.kind = transform_kind(vim_item.kind)
            vim_item.menu = menu

            return vim_item
          end,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip', keyword_length = 2 },
          { name = 'cmp_tabnine' },
          { name = 'buffer', keyword_length = 4 },
          { name = 'path', keyword_length = 4 },
        },
        preselect = { cmp.PreselectMode.None },
      }
    )
  end,
}
