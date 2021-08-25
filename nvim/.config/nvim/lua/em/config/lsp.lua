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

-- Traditional LSP servers
LSP.config.servers = {
  sumneko_lua = {
    cmd = { vim.env.SUMNEKO_EXECUTABLE, '-E', vim.env.SUMNEKO_MAIN_FILE },
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
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          },
        },
      },
    },
  },
  tsserver = {
    -- Note this actually uses the node package `typescript-language-server`,
    -- which wraps the `tsserver` binary.
    on_attach = function(client)
      require('em.lsp').disable_formatting(client)
    end,
  },
  elmls = {
    -- use defaults
  },
  elixirls = {
    cmd = { vim.env.ELIXIR_LS_EXECUTABLE or 'elixir-ls' },
  },
}

-- Tools/utilities wired to LSP via null-ls
LSP.config.tools = {
  sources = {
    -- all files
    null_ls.builtins.formatting.trim_whitespace.with({ filetypes = { '*' } }),
    -- lua
    null_ls.builtins.formatting.stylua,
    -- js/ts
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.diagnostics.eslint,
    -- elm
    null_ls.builtins.formatting.elm_format,
    -- elixir
    require('em.lsp').diagnostics.credo,
  },
}

-- Adjustments to global LSP behavior
LSP.config.handlers = {
  ['textDocument/publishDiagnostics'] = {
    underline = true,
    virtual_text = false,
    signs = false,
    update_in_insert = false,
  },
}

function LSP.setup()
  for server_name, config in pairs(LSP.config.servers) do
    require('lspconfig')[server_name].setup(config)
  end

  null_ls.config(LSP.config.tools)
  require('lspconfig')['null-ls'].setup({})

  if LSP.config.handlers['textDocument/publishDiagnostics'] then
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics,
      LSP.config.handlers['textDocument/publishDiagnostics']
    )
  end
end

return LSP
