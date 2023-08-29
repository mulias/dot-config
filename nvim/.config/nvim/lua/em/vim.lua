--[[----------------------------------------------------------------------------
Lua-Vimscript bridging utilities

Enhances the existing lua api for vimscript. Provides missing vim functionality
and more concise interfaces for the existing lua api.
------------------------------------------------------------------------------]]

local V = {}

-- Check if the current terminal supports true color
function V.can_support_true_color()
  local term = vim.env.TERM
  local is_gvim = vim.fn.has('gui_running') == 1
  local has_truecolor_flag = vim.env.COLORTERM == 'truecolor'
  local is_supported_term = term == 'xterm-256color'
    or term == 'screen-256color'
    or term == 'xterm-kitty'

  return is_gvim or has_truecolor_flag or is_supported_term
end

-- Replaces terminal codes and keycodes with the internal representation.
-- Needed for expression mappings and terminal mode mappings.
function V.tc(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function apply_mode(m, mapping)
  if type(mapping) ~= 'table' then
    return mapping
  end

  local is_namespace = #mapping == 0
  if is_namespace then
    local namespace = {}
    for key, key_mapping in pairs(mapping) do
      namespace[key] = apply_mode(m, key_mapping)
    end
    return namespace
  else
    local mapping_copy = require('em.lua').shallow_copy(mapping)
    mapping_copy['mode'] = m
    return mapping_copy
  end
end

local function register_key(m, k, mapping, opts)
  local register = require('which-key').register
  local utils = require('em.lua')

  if m == 'n' then
    register({ [k] = mapping }, opts)
  else
    local mapping_for_mode = apply_mode(m, mapping)
    local opts_copy = utils.shallow_copy(opts) or {}
    opts_copy['mode'] = m
    register({ [k] = mapping_for_mode }, opts_copy)
  end
end

-- Create keybindings defined by a nested table. Wraps and enhances the
-- `which-keys` plugin. In addition to all of the features of `which-key`, a
-- binding can be made for multiple modes at once by prepending the desired
-- mode chars and a space to the table key. For example:
--
--   ['nx gp'] = { '"+p`]', 'paste from system clipboard' },
--
-- This sets `gp` to paste from the system clipboard in both normal and visual
-- mode. Additionally, the `which-key` menu will show documentation for this
-- key combination in both modes.
-- This method of setting modes should always be used in place of the `mode`
-- opt provided by `which-key`. See `:h map-table` for valid modes.
function V.map(mappings, opts)
  local utils = require('em.lua')

  for key, mapping in pairs(mappings) do
    local modes_and_code = vim.split(key, '%s')
    local has_modes_prefix = modes_and_code[2] ~= nil

    if has_modes_prefix then
      local key_modes = modes_and_code[1]
      local key_code = modes_and_code[2]

      for m in utils.chars(key_modes) do
        register_key(m, key_code, mapping, opts)
      end
    else
      register_key('n', key, mapping, opts)
    end
  end
end

function V.disable_built_in_plugin(plugin_name)
  vim.g['loaded_' .. plugin_name] = 1
end

-- See `:h synIDattr`
-- example: get_highlight_group_attr('StatusLine', 'fg#')
function V.get_highlight_group_attr(hl_group, attr)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hl_group)), attr)
end

function V.get_highlight_group_fg(hl_group)
  local is_reversed = V.get_highlight_group_attr(hl_group, 'reverse') == '1'
  if is_reversed then
    return V.get_highlight_group_attr(hl_group, 'bg#')
  else
    return V.get_highlight_group_attr(hl_group, 'fg#')
  end
end

function V.get_highlight_group_bg(hl_group)
  local is_reversed = V.get_highlight_group_attr(hl_group, 'reverse') == '1'
  if is_reversed then
    return V.get_highlight_group_attr(hl_group, 'fg#')
  else
    return V.get_highlight_group_attr(hl_group, 'bg#')
  end
end

return V
