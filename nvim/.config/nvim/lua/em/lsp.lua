local LSP = {}

local function coerce_nil(val)
  if val == vim.NIL then
    return nil
  else
    return val
  end
end

function LSP.disable_formatting(client)
  client.resolved_capabilities.document_formatting = false
  client.resolved_capabilities.document_range_formatting = false
end

LSP.diagnostics = {
  credo = require('null-ls.helpers').make_builtin({
    method = require('null-ls.methods').internal.DIAGNOSTICS,
    filetypes = { 'elixir' },
    generator_opts = {
      command = 'mix',
      args = {
        'credo',
        '--read-from-stdin',
        '$FILENAME',
        '--strict',
        '--format',
        'json',
        '--mute-exit-status',
      },
      to_stdin = true,
      suppress_errors = true,
      format = 'json',
      on_output = function(params)
        local severities = {
          consistency = 2,
          warning = 2,
          refactor = 3,
          readable = 3,
          design = 4,
        }
        local diagnostics = {}
        for _, issue in ipairs(params.output.issues) do
          table.insert(diagnostics, {
            message = issue.message,
            severity = severities[issue.category],
            row = issue.line_no,
            col = coerce_nil(issue.column),
            end_col = coerce_nil(issue.column_end),
          })
        end
        return diagnostics
      end,
    },
    factory = require('null-ls.helpers').generator_factory,
  }),
}

return LSP
