require('cloak').setup(
  {
    cloak_character = '!',
    highlight_group = 'Error',
    patterns = {
      { file_pattern = '.env*', cloak_pattern = '=.+' },
      {
        file_pattern = 'settings.php',
        cloak_pattern = ' [\'"]password[\'"]%s+=>%s+[\'"].+[\'"],',
      },
    },
  }
)
