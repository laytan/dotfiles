return {
    'saghen/blink.cmp',
    dependencies = {
        { 'saghen/blink.compat', dependencies = { 'tzachar/cmp-tabnine', opts = { show_prediction_strength = true, }, build = './install.sh', }, },
        'rafamadriz/friendly-snippets',
        'echasnovski/mini.icons',
    },
    version = '*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = 'default',

            ['<C-Space>'] = {'show', 'fallback'},
            ['<C-e>'] = {'cancel', 'fallback'},
            ['<Tab>'] = {'select_and_accept', 'fallback'},
        },

        appearance = {
            nerd_font_variant = 'mono',
        },

        sources = {
            default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'cmp_tabnine' },

            providers = {
                lazydev = {
                    name = 'lazydev',
                    module = 'lazydev.integrations.blink',
                    score_offset = 100,
                },
                cmp_tabnine = {
                    name = 'cmp_tabnine',
                    module = 'blink.compat.source',
                },
            },
        },

        completion = {
            menu = {
                draw = {
                    components = {
                        kind_icon = {
                            ellipsis = false,
                            text = function (ctx)
                                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                                return kind_icon
                            end,
                        },
                    },
                },
            },
            documentation = { auto_show = true },
        },
        signature = { enabled = true },
    },

    opts_extend = { 'sources.default' },
}
