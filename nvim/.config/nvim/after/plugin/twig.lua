-- There is no TWIG parser for treesitter, but the twig plugin sets the filetype to
-- html.css.js.twig which makes treesitter enable and the twig plugin's highlighting will be overriden.
-- So for twig filetypes we need to turn treesitter highlighting off so the vim
-- plugin can do all the highlighting.
local group = vim.api.nvim_create_augroup('laytan_vim', {})
vim.api.nvim_create_autocmd(
  'BufEnter',
  { group = group, pattern = '*.twig', command = 'TSBufDisable highlight' }
)
