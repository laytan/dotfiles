local notify = require('notify')

notify.setup({ timeout = 1500, background_colour = '#000000' })

vim.notify = notify
