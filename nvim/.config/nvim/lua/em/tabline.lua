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

local function tab_list()
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

local function tabline()
  local tabs = tab_list()
  local git = vim.fn['fugitive#head']()

  if tabs == '' and git == '' then
    vim.opt.showtabline = 1
  end

  return table.concat({
    tabs,
    '%#TabLineFill#',
    '%=',
    '%#TabLine#',
    '%(%5(%)[%{fugitive#head()}]%)',
  })
end

return tabline
