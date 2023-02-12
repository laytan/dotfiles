-- Mason is used for automatically installing binaries.
return {
  'williamboman/mason.nvim',
  dependencies = { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
  event = 'VeryLazy',
  config = function()
    require('mason').setup()
    require('mason-tool-installer').setup(
      {
        ensure_installed = {
          -- General
          'editorconfig-checker',
          -- PHP
          'phpcs',
          'phpcbf',
          'phpmd',
          'phpstan',
          'php-debug-adapter',
          -- Twig
          { 'twigcs', version = 'v6.1.0' }, -- 6.1 is the last version with PHP7.4 support.
          -- HTML
          'emmet-ls',
          -- GO
          'gopls',
          'delve',
          'golangci-lint',
          'gofumpt',
          'golines',
          'goimports-reviser',
          -- Lua
          'lua-language-server',
          'selene',
          'luaformatter',
          -- CSS
          'tailwindcss-language-server',
          'stylelint-lsp',
          -- JS
          'typescript-language-server',
          'vue-language-server',
          'eslint_d',
          -- Git
          -- Docker
          'hadolint',
          -- Python
          'pyright',
          'isort',
          -- JSON
          'fixjson',
          -- CSharp
          'csharp-language-server',
          -- Terraform
          'terraform-ls',
          -- Yaml
          'yaml-language-server',
        },
      }
    )
  end,
}
