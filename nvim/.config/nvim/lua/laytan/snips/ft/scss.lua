local ls = require('luasnip')

-- local snippet_from_nodes = ls.sn
local s = ls.s
local i = ls.insert_node
-- local t = ls.text_node
-- local d = ls.dynamic_node
-- local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt

return {
  s(
    '!', fmt(
      [[
  !important;
  {}
  ]], { i(0) }
    )
  ),
}

