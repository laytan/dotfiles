-- Waiting for the bugfixes
-- local neotest = require('neotest')
-- neotest.setup(
--   {
--     adapters = {
--       require('neotest-go')(
--         { args = { '-count=1', '-timeout=10s', '-cover', '-race' } }
--       ),
--     },
--     consumers = { overseer = require('neotest.consumers.overseer') },
--     overseer = { enabled = true, force_default = false },
--   }
-- )
--
-- -- Run hovered test (Test this)
-- vim.keymap.set(
--   'n', '<leader>tt', function()
--     neotest.overseer.run()
--   end
-- )
--
-- -- Run previous test (Test previous)
-- vim.keymap.set(
--   'n', '<leader>tp', function()
--     neotest.overseer.run_last()
--   end
-- )
--
-- -- Run all tests (Test all)
-- vim.keymap.set(
--   'n', '<leader>ta', function()
--     neotest.overseer.run({ suite = true })
--   end
-- )
--
-- -- Test overview
-- vim.keymap.set(
--   'n', '<leader>to', function()
--     neotest.summary.toggle()
--   end
-- )
--
-- local namespace = vim.api.nvim_create_namespace('neotest')
-- vim.diagnostic.enable(nil, namespace)
