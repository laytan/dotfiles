local ls = require('luasnip')

local s = ls.s
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

return {
  -- s( 'in', {
  --   t('if '),
  --   rep(1),
  --   i(2),
  --   c(3, { t(' in '), t(' not_in ') }),
  --   i(1),
  --   t({' {', '\t'}),
  --   i(0),
  --   t({'', '}'}),
  -- }),
  s('in', fmt("if {}{} {} {} {{\n\t{}\n}}", {
    rep(1),
    i(2),
    c(3, { t('in'), t('not_in') }),
    i(1),
    i(0),
  })),
}

