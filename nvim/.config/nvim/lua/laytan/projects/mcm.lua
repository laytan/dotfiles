local cakeroutes = require('cakeroutes')

cakeroutes.setup(
  {
    cache = true,
    cmd = { 'docker', 'exec', '-i', 'mcm_mcm', 'bin/cake', 'routes' },
  }
)

