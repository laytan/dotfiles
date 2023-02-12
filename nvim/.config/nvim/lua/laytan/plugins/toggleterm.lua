local ray = nil

return {
  'akinsho/toggleterm.nvim',
  keys = {
    {
      '<leader>sr',
      function()
        ray:toggle()
      end,
    },
    { '<leader>tt', '<cmd>ToggleTerm<cr>' },
  },
  config = function()
    require('toggleterm').setup({ start_in_insert = false, hide_numbers = true })

    local Terminal = require('toggleterm.terminal').Terminal

    ray = Terminal:new(
      {
        cmd = '~/projects/ray-cli/ray-cli',
        hidden = true,
        close_on_exit = true,
        direction = 'tab',
        on_stdout = function(t)
          -- Open the terminal when a ray is received.
          if not t:is_focused() then
            t:focus()
          end
        end,
        on_open = function()
          -- Set the tab name.
          vim.api.nvim_tabpage_set_var(0, 'tabname', 'Ray')
        end,
      }
    )
  end,
}
