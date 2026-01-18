-- TODO: doesn't seem to work.

local M = {}

---Get the saved data for this extension
---@param opts resession.Extension.OnSaveOpts Information about the session being saved
---@return any
M.on_save = function(opts)
  	return {
		quick_command_current_command = require('laytan.quick_command').current_command,
	}
end

---Restore the extension state
---@param data The value returned from on_save
M.on_pre_load = function(data)
	-- This is run before the buffers, windows, and tabs are restored
	if data.quick_command_current_command ~= nil then
    	require('laytan.quick_command').current_command = data.quick_command_current_command
    end
end

---Restore the extension state
---@param data The value returned from on_save
M.on_post_load = function(data)
  -- This is run after the buffers, windows, and tabs are restored
end

---Called when resession gets configured
---This function is optional
---@param data table The configuration data passed in the config
M.config = function(data)
  --
end

return M
