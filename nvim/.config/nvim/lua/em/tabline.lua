local Tabline = {}

local function tabSeparator(current)
  return (current < vim.fn.tabpagenr('$') and '%#TabLine#|' or '')
end

local function formatTab(current)
  local isSelected = vim.fn.tabpagenr() == current
  local hl = (isSelected and '%#TabLineSel#' or '%#TabLine#')

  return table.concat({
    hl,
    '%',
    current,
    'T',
    ' ',
    current,
    ' ',
    '%T',
    tabSeparator(current),
  })
end

-- List tab pages by number. The result of this function must be re-evaluated
-- if called in the tabline, see the `{%` value in `:h statusline`.
function Tabline.tab_list()
  local tabs_count = vim.fn.tabpagenr('$')

  if tabs_count == 1 then
    return ''
  else
    local i = 1
    local line = ''
    while i <= tabs_count do
      line = line .. formatTab(i)
      i = i + 1
    end
    return line
  end
end

-- List language servers currently active for the vim session
function Tabline.lsp_servers()
  local servers = vim.lsp.get_active_clients()
  local server_names = {}
  for _, server in ipairs(servers) do
    table.insert(server_names, server.name)
  end

  if #server_names > 0 then
    return 'LSP: ' .. table.concat(server_names, ', ')
  else
    return ''
  end
end

return Tabline
