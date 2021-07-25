--[[----------------------------------------------------------------------------
Wrappers for some vim features that do not yet have a lua interface, or could
have a better interface.
------------------------------------------------------------------------------]]

local UtilVim = {}

__FnMapStore = __FnMapStore or {}

__execute_fn_map = function(id)
  __FnMapStore[id]()
end

local create_fn_map = function(f)
  table.insert(__FnMapStore, f)
  return #__FnMapStore
end

local make_cmd = function(rhs)
  if type(rhs) == 'string' then
    return rhs
  elseif type(rhs) == 'function' then
    local func_id = create_fn_map(rhs)
    return string.format('lua __execute_fn_map(%s)<CR>', func_id)
  else
    error('Unexpected type for rhs: ' .. tostring(rhs))
  end
end

function UtilVim.augroup(group_name, cmd_defs)
  vim.cmd('augroup ' .. group_name)
  vim.cmd('autocmd!')
  for _, cmd_def in ipairs(cmd_defs) do
    vim.cmd('autocmd ' .. table.concat(cmd_def, ' '))
  end
  vim.cmd('augroup END')
  return group_name
end

function UtilVim.cmd(name, cmd_body, opts)
  local cmd = make_cmd(cmd_body)

  local nargs = opts.nargs or 0
  local bang
  if opts.bang then
    bang = '-bang'
  else
    bang = ''
  end

  vim.cmd(
    table.concat({ 'command!', bang, '-nargs=' .. nargs, name, cmd }, ' ')
  )
end

function UtilVim.is_true_color_term()
  local term = vim.env.TERM
  local is_true_color_term = term == 'xterm-256color'
    or term == 'screen-256color'
    or term == 'xterm-kitty'
  return is_true_color_term
end

function UtilVim.tc(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function apply_mode(m, mapping)
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

function register_key(m, k, mapping, opts)
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

-- Wrap and enhance the `which-keys` plugin for setting many mappings
-- via a table.
function UtilVim.map(mappings, opts)
  local register = require('which-key').register
  local utils = require('em.lua')
  local mappings_by_mode = {}

  for key, mapping in pairs(mappings) do
    local modes_and_code = utils.split_str(key)
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

return UtilVim
