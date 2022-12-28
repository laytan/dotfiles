return {
  { 'mfussenegger/nvim-dap-python', lazy = true },
  {
    'mfussenegger/nvim-dap', -- Core functionality for debugging.
    dependencies = {
      'rcarriga/nvim-dap-ui', -- Adds a UI to the debugger.
      'theHamsta/nvim-dap-virtual-text', -- Shows information from the debugging session next to code as virtual text.
    },
    keys = {
      '<leader>bo',
      '<leader>bc',
      '<leader>bb',
      '<leader>bB',
      '<Right>',
      '<Up>',
      '<Down>',
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      require('nvim-dap-virtual-text').setup({})

      dapui.setup()

      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open({})
      end

      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close({})
      end

      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close({})
      end

      vim.keymap.set('n', '<leader>bo', dapui.toggle)
      vim.keymap.set('n', '<leader>bc', ':DapContinue<cr>')
      vim.keymap.set('n', '<leader>bb', ':DapToggleBreakpoint<cr>')
      vim.keymap.set(
        'n', '<leader>bB', function()
        dap.toggle_breakpoint(vim.fn.input('[DAP] Condition > '))
      end
      )
      vim.keymap.set('n', '<Right>', dap.step_over)
      vim.keymap.set('n', '<Up>', dap.step_out)
      vim.keymap.set('n', '<Down>', dap.step_into)

      -- catppuccin
      local sign = vim.fn.sign_define
      sign(
        'DapBreakpoint',
        { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = '' }
      )
      sign(
        'DapBreakpointCondition', {
        text = '●',
        texthl = 'DapBreakpointCondition',
        linehl = '',
        numhl = '',
      }
      )
      sign(
        'DapLogPoint',
        { text = '◆', texthl = 'DapLogPoint', linehl = '', numhl = '' }
      )

      -- Map of configuration per filetype, this lazy loads, so we don't load
      -- each dap adapter/language when we run.
      local filetypes = {
        python = {
          configured = false,
          config = function()
            local dap_python = require('dap-python')
            dap_python.setup('~/.virtualenvs/debugpy/bin/python')
            dap_python.resolve_python = function()
              return '/Users/laytan/.pyenv/shims/python'
            end
          end,
        },

        go = {
          configured = false,
          config = function()
            require('gopher.dap').setup()
          end,
        },

        php = {
          configured = false,
          config = function()
            dap.adapters.php = {
              type = 'executable',
              command = 'php-debug-adapter',
            }

            dap.configurations.php = {
              {
                type = 'php',
                request = 'launch',
                name = 'Listen for Xdebug',
                port = 9003,
              },
            }
          end,
        },
      }

      local on_ft = function(ft)
        local curr_ft = filetypes[ft]
        if curr_ft and not curr_ft.configured then
          vim.notify(
            'Lazy loading ' .. ft .. ' DAP configuration', vim.log.levels.INFO
          )
          curr_ft.config()
          curr_ft.configured = true
        end
      end
      on_ft(vim.bo.filetype)

      local ft_pattern = {}
      for k, _ in pairs(filetypes) do
        table.insert(ft_pattern, k)
      end

      vim.api.nvim_create_autocmd(
        'FileType', {
        pattern = ft_pattern,
        callback = function(data)
          on_ft(data.match)
        end,
      }
      )
    end,
  },
}