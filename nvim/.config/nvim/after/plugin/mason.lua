require('mason').setup()

require('mason-tool-installer').setup(
  {
    ensure_installed = {
      -- General
      'editorconfig-checker',
      -- PHP
      'phpactor',
      'phpcs',
      'phpcbf',
      'phpmd',
      'phpstan',
      'php-debug-adapter',
      -- Twig
      'twigcs',
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
