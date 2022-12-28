-- Cloak protects secrets from screen sharing or pair programming.
return {
  'laytan/cloak.nvim',
  dev = true,
  event = 'BufReadPre',
  config = {},
}
