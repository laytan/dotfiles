require('mason').setup()

-- Missing:
--  stylelint_lsp

require('mason-tool-installer').setup(
  {
    ensure_installed = {
      -- GO
      'gopls',
      'delve',

      -- LUA
      'lua-language-server',

      -- Frontend
      'typescript-language-server',
      'tailwindcss-language-server',
      'vue-language-server',
      'emmet-ls',

      -- CSharp
      'csharp-language-server',

      -- Python
      'pyright',

      -- PHP
      'phpactor',
    },
  }
)
