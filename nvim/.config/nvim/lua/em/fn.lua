--[[----------------------------------------------------------------------------
Automate specific vim tasks
------------------------------------------------------------------------------]]

local Fn = {}

-- Show/hide colored columns to eyeball code length If a buffer
-- already has one or more color colomns then show/hide those
-- columns. If the buffer does not have any color columns then create
-- `default_columns`, which itself defaults to `{ '81' }`.
function Fn.toggle_color_columns(columns)
  local default_columns = columns or { '81' }
  local has_cc = #vim.opt_local.colorcolumn:get() > 0
  if has_cc then
    vim.b.prev_colorcolumn = vim.opt_local.colorcolumn:get()
    vim.opt_local.colorcolumn = {}
  else
    local new_cc = vim.b.prev_colorcolumn or default_columns
    vim.opt_local.colorcolumn = new_cc
  end
end

-- Check if format is enabled on the global or buffer level
local function is_format_on_write_enabled()
  return vim.b.format_on_write == true
    or (
      vim.g.format_on_write_start_enabled == true
      and vim.b.format_on_write == nil
    )
end

-- Enable/disable the formatting performed by `format_buffer_if_enabled`.
function Fn.toggle_format_on_write()
  if is_format_on_write_enabled() then
    vim.b.format_on_write = false
    print('Formatting disabled')
  else
    vim.b.format_on_write = true
    print('Formatting enabled')
  end
  return vim.b.format_on_write
end

-- Remove trailing whitespace and convert tabs to spaces in the current buffer.
function Fn.basic_format_buffer()
  -- http://stackoverflow.com/q/356126
  local search = vim.fn.getreg('/')
  local view = vim.fn.winsaveview()
  vim.cmd('retab')
  vim.cmd([[silent! %s/\s\+$//e]])
  vim.fn.setreg('/', search)
  vim.fn.winrestview(view)
end

-- Apply both the basic formatter and the formatting provided by Neoformat.
function Fn.format_buffer()
  Fn.basic_format_buffer()
  vim.cmd('Neoformat')
end

-- Format buffer unless format_on_write is disabled for the buffer.
function Fn.format_buffer_if_enabled()
  if is_format_on_write_enabled() then
    Fn.format_buffer()
  end
end

-- Check if window resizing is enabled globally
local function is_window_resize_enabled()
  return vim.g.window_resize_enabled == true
    or (
      vim.g.window_resize_start_enabled == true
      and vim.g.window_resize_enabled == nil
    )
end

-- Resize windows unless window_resize is disabled. Does not run the Focus
-- plugin, since the effects of Focus are passive.
function Fn.window_resize_if_enabled()
  if is_window_resize_enabled() then
    vim.cmd('wincmd=')
  end
end

-- Enable/disable window resize behavior
function Fn.toggle_window_resize()
  if is_window_resize_enabled() then
    vim.g.window_resize_enabled = false
    Fn.sync_window_resize_settings()
    print('Window auto-resize disabled')
  else
    vim.g.window_resize_enabled = true
    Fn.sync_window_resize_settings()
    Fn.window_resize_if_enabled()
    print('Window auto-resize enabled')
  end

  return vim.g.window_resize_enabled
end

-- Ensure that the Focus plugin is enabled/disabled to match the
-- window_resize_enabled flag.
function Fn.sync_window_resize_settings()
  if is_window_resize_enabled() then
    vim.cmd('EnableFocus')
  else
    vim.cmd('DisableFocus')
  end
end

-- Check if highlighting on yank is enabled on the global or buffer level
local function is_highlight_on_yank_enabled()
  return vim.b.highlight_on_yank == true
    or (
      vim.g.highlight_on_yank_start_enabled == true
      and vim.b.highlight_on_yank == nil
    )
end

-- Highlight text that was just yanked unless highlight_on_yank is disabled for
-- the buffer.
function Fn.highlight_yank_if_enabled()
  if is_highlight_on_yank_enabled() then
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 1000 })
  end
end

-- Enable/disable highlighting yanked text
function Fn.toggle_highlight_yank()
  if is_highlight_on_yank_enabled() then
    vim.b.highlight_on_yank = false
    print('Highligh on yank disabled')
  else
    vim.b.highlight_on_yank = true
    print('Highlight on yank enabled')
  end

  return vim.b.highlight_on_yank
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

-- Change Spelling related groups to use an underline, overriding the undercurl
-- sometimes used by colorschemes.
function Fn.underline_spell_groups()
  for _, group in ipairs({ 'SpellBad', 'SpellCap', 'SpellRare', 'SpellLocal' }) do
    vim.cmd('highlight clear ' .. group)
    vim.cmd('highlight ' .. group .. ' gui=underline')
  end
end

-- Change LSP related groups to use an underline, overriding the undercurl
-- sometimes used by colorschemes.
function Fn.underline_lsp_groups()
  for _, group in ipairs({
    'LspDiagnosticsUnderlineError',
    'LspDiagnosticsUnderlineWarning',
    'LspDiagnosticsUnderlineInformation',
    'LspDiagnosticsUnderlineHint',
  }) do
    vim.cmd('highlight clear ' .. group)
    vim.cmd('highlight ' .. group .. ' gui=underline')
  end
end

-- Try to make the bar between vertical window splits visible by setting it to
-- the same color as non-active statuslines.
function Fn.always_show_vert_split()
  local em_vim = require('em.vim')
  local normal_bg = em_vim.get_highlight_group_bg('Normal')
  local vert_split_fg = em_vim.get_highlight_group_fg('VertSplit')
  local is_vert_split_hidden = normal_bg == vert_split_fg and normal_bg ~= ''

  if is_vert_split_hidden then
    local non_current_status_line_background_color =
      em_vim.get_highlight_group_bg(
        'StatusLineNC'
      )

    vim.cmd('highlight clear VertSplit')
    vim.cmd(
      'highlight VertSplit guifg=' .. non_current_status_line_background_color
    )
  end
end

-- Try to hide the `~` lines after the end of the buffer by setting them to the
-- same color as the editor background.
function Fn.hide_end_of_buffer_symbols()
  local em_vim = require('em.vim')
  local background_color = em_vim.get_highlight_group_bg('Normal')

  if background_color ~= '' then
    vim.cmd('highlight clear EndOfBuffer')
    vim.cmd('highlight EndOfBuffer guifg=' .. background_color)
  end
end

-- Don't style the cursorline when the `cursorline` opt is on, but do highlight
-- the line number.
function Fn.subtle_highlight_cursorline()
  vim.cmd('highlight clear CursorLine')
end

return Fn
