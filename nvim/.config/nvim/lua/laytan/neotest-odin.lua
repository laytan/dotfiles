local lib = require("neotest.lib")
local async = require("neotest.async")
local nio = require("nio")

-- HACK: hack around a bug in neotest, they use this plenary.filetype module wrapped in a memoization
-- function, and this library sets up filetype detection on the first call, meaning the first call
-- can return no match (which is weird and bad by itself) but that is compounded by neotest just
-- using that value for ever afterwards.
-- This call will cause plenary to load the filetype and makes neotest later memoize the right thing.
require("plenary.filetype").detect_from_extension("test.odin")

---@type neotest.Adapter
local adapter = { name = "neotest-odin", dap = { adapter = "" } }

adapter.root = lib.files.match_root_pattern("ols.json", ".git")

function adapter.is_test_file(file_path)
  local is_test = vim.endswith(file_path, ".odin")
  if is_test then
    -- NOTE: to not show files without tests in the UI, we have to check this here too :(
    is_test = next(adapter.discover_positions(file_path)._children) ~= nil
  end

  return is_test
end

function adapter.discover_positions(file_path)
  local query = [[
    (package_declaration (identifier) @namespace.name) @namespace.definition

    (procedure_declaration
      (attributes
        (attribute
          (identifier) @_attr (#eq? @_attr "test")))
      (identifier) @test.name
    ) @test.definition
  ]]

  local namespace = ""
  local tree = lib.treesitter.parse_positions(file_path, query, {
    require_namespaces = false,
    nested_tests = false,
    position_id = function (position, parents)
      if position.type == "namespace" then
        assert(namespace == "", "double namespace?")
        namespace = position.name
      end

      if position.type == "test" then
        local id = namespace .. "." .. position.name
        return id
      end

      return nil
    end
  })
  return tree
end

---@async
---@param args neotest.RunArgs
---@return neotest.RunSpec
function adapter.build_spec(args)
  local results_path = async.fn.tempname()
  local position = args.tree:data()
  local location = position.path

  if vim.fn.isdirectory(position.path) ~= 1 then
    location = vim.fn.fnamemodify(position.path, ":h")
  end

  local ids = {}
  for _, node in args.tree:iter_nodes() do
    local value = node:data()
    if value.type == "test" then
      table.insert(ids, value.id)
    end
  end
  local test_names = vim.fn.join(ids, ",")

  local bin_path = async.fn.tempname()

  if args.strategy == "dap" then

    -- build a temp binary.
    local future = nio.control.future()
    local build_command = {
      "odin",
      "build",
      location,
      "-debug",
      "-build-mode:test",
      "-all-packages",
      "-error-pos-style:unix",
      "-out:" .. bin_path,
      "-define:ODIN_TEST_FANCY=false",
      "-define:ODIN_TEST_NAMES=" .. test_names,
      "-define:ODIN_TEST_JSON_REPORT=" .. results_path,
      "-define:ODIN_TEST_GO_TO_ERROR=true",
    }
    vim.system(build_command, { text = true }, function(out)
        if (out.code == 0) then
          future.set()
        else
          future.set_error(out.stderr)
        end
      end)
    local build_success, build_error_message = pcall(future.wait)

    return {
      cwd = location,
      context = {
        strategy = "dap",
        results_path = results_path,
        build_success = build_success,
        build_error_message = build_error_message,
      },
      -- TODO: should be configurable.
      strategy = {
        name = "Debug Test",
        type = "codelldb",
        request = "launch",
        initCommands = {
          "command source ~/.lldbinit",
        },
        program = bin_path,
      },
    }
  else
    local result = {
      command = "odin test . -all-packages -error-pos-style:unix -out:\"" .. bin_path .. "\" -define:ODIN_TEST_FANCY=false -define:ODIN_TEST_NAMES=" .. test_names .. " -define:ODIN_TEST_JSON_REPORT=\"" .. results_path .. "\" -define:ODIN_TEST_GO_TO_ERROR=true",
      cwd = location,
      context = {
        results_path = results_path,
      },
    }
    return result
  end
end

---@async
---@param spec neotest.RunSpec
---@param result neotest.StrategyResult
---@param tree neotest.Tree
---@return table<string, neotest.Result[]>
function adapter.results(spec, result, tree)

  local function remove_prefix(str, prefix)
    if str:sub(1, #prefix) == prefix then
      return str:sub(#prefix + 2)
    else
      return str
    end
  end

  local function map_errors(errors, path)
    local neoerrors = {}
    for _, error in ipairs(errors) do
      -- NOTE: only accepts line, only wants errors in the file of the test.
      if error.location.file_path == path then
        table.insert(neoerrors, {
          message = error.message,
          line    = error.location.line - 1,
        })
      end
    end
    return neoerrors
  end

  local function map_short(errors, cwd)
    local neoerrors = {}
    for _, error in ipairs(errors) do
      local path = remove_prefix(error.location.file_path, cwd)

      table.insert(neoerrors, path .. ":" .. error.location.line .. ":" .. error.location.column .. ": " .. error.location.procedure .. "() " .. error.message)
    end
    return table.concat(neoerrors, "\n")
  end

  local results = {}

  -- Build failure with DAP strategy.
  if spec.context.strategy == "dap" and not spec.context.build_success then
    local out_path = async.fn.tempname()
    lib.files.write(out_path, spec.context.build_error_message)

    for _, node in tree:iter_nodes() do
      local value = node:data()
      results[value.id] = {
        status = "skipped",
        short = spec.context.build_error_message,
        output = out_path,
      }
    end

    results[tree:data().id] = {
      status = "failed",
      short = spec.context.build_error_message,
      output = out_path,
    }

    return results
  end

  local ok, output = pcall(lib.files.read, spec.context.results_path)
  -- If there is no test report compiling must've failed, set first node as failed, rest as skipped.
  if not ok then
    for _, node in tree:iter_nodes() do
      local value = node:data()
      results[value.id] = {
        status = "skipped",
      }
    end

    results[tree:data().id] = {
      status = "failed"
    }

    return results
  end

  local report = vim.json.decode(output)
  for _, node in tree:iter_nodes() do
    local value = node:data()

    if value.type == "test" then
      -- Mark as skipped when it doesn't come up in the report.
      results[value.id] = {
        status = "skipped",
      }

      local parts = vim.split(value.id, ".", {plain=true})
      local pkg   = parts[1]
      local name  = parts[2]

      pkg_tests = report.packages[pkg]
      if pkg_tests then
        for _, test in ipairs(pkg_tests) do
          if test.name == name then
            if test.success then
              results[value.id] = {
                status = "passed",
              }
            else
              results[value.id] = {
                status = "failed",
                short  = map_short(test.errors, spec.cwd),
                errors = map_errors(test.errors, value.path),
              }
            end
            break
          end
        end
      end
    end
  end

  return results
end

return adapter

