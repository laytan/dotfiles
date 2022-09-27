local colorizer = require('colorizer')

colorizer.setup(
  {
    user_default_options = {
      rgb_fn = true,
      hsl_fn = true,
      tailwind = 'lsp',
      sass = { enable = true },
    },
  }
)
