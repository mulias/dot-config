local M = {}

-- Show/hide a vertical line at column 81 to eyeball code length
function M.toggle_color_column()
  local cc = vim.api.nvim_win_get_option(0, 'colorcolumn')
  if cc == '' then
    vim.api.nvim_win_set_option(0, 'colorcolumn', '81')
  else
    vim.api.nvim_win_set_option(0, 'colorcolumn', '')
  end
end

-- Set a buffer var to indicate if neoformat should run
function M.neoformat_toggle()
  if vim.b.neoformat_disabled then
    vim.b.neoformat_disabled = false
    print('Neoformat enabled')
  else
    vim.b.neoformat_disabled = true
    print('Neoformat disabled')
  end
  return vim.b.neoformat_disabled
end

-- Run neoformat unless it has explicitly been disabled
function M.neoformat_if_enabled()
  if not vim.b.neoformat_disabled then
    vim.cmd('Neoformat')
  end
end

-- Format information about the most serious ALE issues for the current file
function M.ale_status()
  local issues = vim.api.nvim_eval('ale#statusline#Count(bufnr("%"))')
  if issues.total > 0 then
    if issues.error > 0 then
      return 'ERRORS: ' .. issues.error
    elseif issues.warning > 0 then
      return 'WARNINGS: ' .. issues.warning
    elseif (issues.style_error + issues.style_warning) > 0 then
      return 'STYLE: ' .. (issues.style_error + issues.style_warning)
    elseif issues.info > 0 then
      return 'INFO: ' .. issues.info
    end
  end

  return ''
end

return M
