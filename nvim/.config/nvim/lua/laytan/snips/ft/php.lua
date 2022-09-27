local ts_utils = require('laytan.treesitter')
local ls = require('luasnip')
local s = ls.s
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local f = ls.function_node
local fmt = require('luasnip.extras.fmt').fmt

local function remove_static_class(class)
  local var_name = ''

  local parts = vim.fn.split(class, ':')
  if parts[1] == nil then
    var_name = class
  else
    var_name = parts[1]
  end

  return var_name or ''
end

vim.treesitter.set_query(
  'php', 'LuaSnip_Result_Namespaces', [[ [
    (namespace_use_clause
      (qualified_name) @used_namespace)

    (namespace_definition
      name: (namespace_name) @namespace)
  ] ]]
)

local function get_namespace(class)
  class = class or ''
  local file_namespace = ''

  local query = vim.treesitter.get_query('php', 'LuaSnip_Result_Namespaces')
  for id, node in ts_utils.iter_captures_up(query) do
    local name = query.captures[id]
    local text = ts_utils.get_node_text(node)

    if name == 'used_namespace' and #class > 0 and text:match(class .. '$') then
      return '\\' .. text
    elseif name == 'namespace' then
      file_namespace = '\\' .. text .. '\\' .. class
    end
  end

  return file_namespace
end

local function ts_namespace_of_symbol(args)
  local class_string = remove_static_class(args[1][1])
  return get_namespace(class_string) or ''
end

local function camel_cased_var(class_string)
  class_string = class_string[1][1]
  local var_name = remove_static_class(class_string)
  return var_name:sub(1, 1):lower() .. var_name:sub(2)
end

return {
  ---------------------------------------------------------------------- Drupal
  s(
    { trig = 'dser', name = 'Drupal static service' }, fmt(
      [[
      /** @var {} */
      ${}{} = \Drupal::service({});
      {}
      ]], {
      f(ts_namespace_of_symbol, { 2 }),
      c(1, { t('this->'), t('instance->'), t('') }),
      f(camel_cased_var, { 2 }),
      i(2),
      i(0),
    }
    )
  ),
  s(
    { trig = 'dpro', name = 'Drupal class property' }, fmt(
      [[
      /**
       * {}
       *
       * @var {}
       */
      {} {} ${};
      {}
      ]], {
      i(3),
      f(ts_namespace_of_symbol, { 2 }),
      c(1, { t('private'), t('public'), t('protected') }),
      i(2),
      f(camel_cased_var, { 2 }),
      i(0),
    }
    )
  ),
  s(
    { trig = 'dcre', name = 'Drupal create method' }, fmt(
      [[
    /**
     * {{@inheritdoc}}
     */
     public static function create(ContainerInterface $container): self {{
       $instance = parent::create($container);

       {}

       return $instance;
     }}
     {}
    ]] , { i(1), i(0) }
    )
  ),
  ---------------------------------------------------------------------- Elephp
  s(
    { trig = 't_', name = 'Elephp test case' }, fmt(
      [[// @t_{}({}, {})]],
      { c(1, { t('in'), t('out'), t('nodef') }), i(2), i(0) }
    )
  ),
}
