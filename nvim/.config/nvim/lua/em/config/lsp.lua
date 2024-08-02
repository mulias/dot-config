--[[----------------------------------------------------------------------------
Language Servers

Use neovim's built in LSP client for diagnostics, linting, and formatting. We
define a number of servers for different languages, and then also use `null-ls`
to turn other utilities into language server sources.

Note that in general these configurations assume a globally available
executable, but in practice we usually want per-project versions of tools and
servers. One way to get around this issue is to use a nix-shell for each
project, and configure the shell to add desired executables to the $PATH.
------------------------------------------------------------------------------]]

local null_ls = require('null-ls')

local LSP = {}

LSP.config = {}

LSP.config.servers = {
  {
    name = 'lua_ls',
    enabled = vim.env.NVIM_NVIM_LUA_LSP == 'true',
    settings = {
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = vim.split(package.path, ';'),
          },
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
          },
          telemetry = {
            enable = false,
          },
        },
      },
      on_attach = function(client)
        require('em.lsp').disable_formatting(client)
      end,
    },
  },
  {
    name = 'tsserver',
    enabled = vim.env.NVIM_TYPESCRIPT_LSP == 'true',
    settings = {
      -- Note this actually uses the node package `typescript-language-server`,
      -- which wraps the `tsserver` binary.
      on_attach = function(client)
        require('em.lsp').disable_formatting(client)
      end,
    },
  },
  {
    name = 'elmls',
    enabled = vim.env.NVIM_ELM_LSP == 'true',
    settings = {},
  },
  {
    name = 'elixirls',
    enabled = vim.env.NVIM_ELIXIR_LSP == 'true',
    settings = {
      cmd = { vim.env.ELIXIR_LS_EXECUTABLE or 'elixir-ls' },
      settings = {
        dialyzerEnabled = false,
      },
    },
  },
  {
    name = 'roc_ls',
    enabled = vim.env.NVIM_ROC_LS == 'true',
    settings = {},
  },
  {
    name = 'rust_analyzer',
    enabled = vim.env.NVIM_RUST_LSP == 'true',
    settings = {},
  },
  {
    name = 'tailwindcss',
    enabled = vim.env.NVIM_TAILWINDCSS_LSP == 'true',
    settings = {},
  },
  {
    name = 'ocamllsp',
    enabled = vim.env.NVIM_OCAML_LSP == 'true',
    settings = {},
  },
  {
    name = 'zls',
    enabled = vim.env.NVIM_ZIG_LSP == 'true',
    settings = {},
  },
  {
    name = 'null-ls',
    enabled = vim.env.NVIM_STYLUA_LSP == 'true',
    settings = null_ls.builtins.formatting.stylua,
  },
  {
    name = 'null-ls',
    enabled = vim.env.NVIM_PRETTIER_LSP == 'true',
    settings = null_ls.builtins.formatting.prettier,
  },
  {
    name = 'null-ls',
    enabled = vim.env.NVIM_ESLINT_LSP == 'true',
    settings = null_ls.builtins.diagnostics.eslint,
  },
  {
    name = 'null-ls',
    enabled = vim.env.NVIM_ELM_FORMAT_LSP == 'true',
    settings = null_ls.builtins.formatting.elm_format,
  },
  {
    name = 'null-ls',
    enabled = vim.env.NVIM_CREDO_LSP == 'true',
    settings = null_ls.builtins.diagnostics.credo.with({
      args = {
        'credo',
        '--strict',
        '--format',
        'json',
        '--read-from-stdin',
        '$FILENAME',
      },
    }),
  },
  {
    name = 'null-ls',
    enabled = vim.env.NVIM_RUFO_LSP == 'true',
    settings = null_ls.builtins.formatting.rufo,
  },
}

local configs = require('lspconfig.configs')

if not configs.roc_ls then
  configs.roc_ls = {
    default_config = {
      cmd = { 'roc_ls' },
      filetypes = { 'roc' },
      root_dir = function(fname)
        return require('lspconfig').util.find_git_ancestor(fname)
      end,
      settings = {},
    },
  }
end

function LSP.setup()
  local null_ls_sources = {}

  for _, server_config in pairs(LSP.config.servers) do
    if server_config.enabled then
      if server_config.name == 'null-ls' then
        table.insert(null_ls_sources, server_config.settings)
      else
        require('lspconfig')[server_config.name].setup(server_config.settings)
      end
    end
  end

  null_ls.setup({ sources = null_ls_sources })

  vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    signs = false,
    update_in_insert = false,
  })
end

function LSP.reload()
  return require('em.lua').reload('em.config.lsp')
end

return LSP
