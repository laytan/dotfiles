return {
  'axkirillov/hbac.nvim',
  config = function()
    local hbac = require('hbac')

    local disabled = false

    hbac.setup(
      {
        close_command = function(bufnr)
          if disabled then
            return
          end
          vim.api.nvim_buf_delete(bufnr, {})
        end,
      }
    )

    vim.api.nvim_create_user_command(
      'HbacDisable', function()
        disabled = true
      end, {}
    )
    vim.api.nvim_create_user_command(
      'HbacEnable', function()
        disabled = false
      end, {}
    )
    vim.api.nvim_create_user_command(
      'HbacToggle', function()
        disabled = disabled
      end, {}
    )
  end,
}
