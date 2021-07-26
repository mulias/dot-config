--[[----------------------------------------------------------------------------
Automate specific vim tasks
------------------------------------------------------------------------------]]

local Fn = {}

-- Show/hide colored columns to eyeball code length If a buffer
-- already has one or more color colomns then show/hide those
-- columns. If the buffer does not have any color columns then create
-- `default_columns`, which itself defaults to `{ '81' }`.
function Fn.toggle_color_columns(default_columns)
  local default_columns = default_columns or { '81' }
  local has_cc = #vim.opt_local.colorcolumn:get() > 0
  if has_cc then
    vim.b.prev_colorcolumn = vim.opt_local.colorcolumn:get()
    vim.opt_local.colorcolumn = {}
  else
    local new_cc = vim.b.prev_colorcolumn or default_columns
    vim.opt_local.colorcolumn = new_cc
  end
end

-- Set a buffer var to indicate if neoformat should run. Since
function Fn.neoformat_toggle()
  local neoformat_enabled = vim.b.neoformat_enabled == true
    or (vim.g.neoformat_start_enabled == 1 and vim.b.neoformat_enabled == nil)

  if neoformat_enabled then
    vim.b.neoformat_enabled = false
    print('Neoformat disabled')
  else
    vim.b.neoformat_enabled = true
    print('Neoformat enabled')
  end
  return vim.b.neoformat_enabled
end

-- Run neoformat unless it has explicitly been disabled
function Fn.neoformat_if_enabled()
  if not vim.b.neoformat_disabled then
    vim.cmd('Neoformat')
  end
end

-- Format information about the most serious ALE issues for the current file
function Fn.ale_status()
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

return Fn
