--[[
Wrappers for some vim features that do not yet have a lua interface, or could
have a better interface.
--]]

local M = {}

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
    error("Unexpected type for rhs:" .. tostring(rhs))
  end
end

local opts_info = vim.api.nvim_get_all_options_info()

M.opt = setmetatable({}, {
  __index = vim.o,
  __newindex = function(_, key, value)
    vim.o[key] = value
    local scope = opts_info[key].scope
    if scope == "win" then
      vim.wo[key] = value
    elseif scope == "buf" then
      vim.bo[key] = value
    end
  end,
})

function M.opts(opts_table)
  for k, v in pairs(opts_table) do
    M.opt[k] = v
  end
end

function M.augroup(group_name, cmd_defs)
  vim.cmd('augroup '..group_name)
  vim.cmd('autocmd!')
  for _, cmd_def in ipairs(cmd_defs) do
    vim.cmd('autocmd '..table.concat(cmd_def, ' '))
  end
  vim.cmd('augroup END')
  return group_name
end

function M.autocmd(group, event, pat, cmd)
  vim.cmd(table.concat({'autocmd', group, event, pat, cmd}, ' '))
end

function M.def_cmd(opts)
  local name = opts[1]
  local cmd = make_cmd(opts[2])

  local nargs = opts.nargs or 0
  local bang
  if opts.bang then
    bang = '-bang'
  else
    bang = ''
  end

  vim.cmd(table.concat({'command!', bang, '-nargs='..nargs, name, cmd}, ' '))
end

return M
