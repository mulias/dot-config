--[[----------------------------------------------------------------------------
Lua utilities

See `:h lua-vim` for lua utils already implemented and bundled with neovim.
------------------------------------------------------------------------------]]

local L = {}

-- Inspect lua data
function L.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
  return ...
end

-- Iterator for the chars in a string
function L.chars(str)
  return string.gmatch(str, '.')
end

-- Shallow copy table
function L.shallow_copy(original)
  if type(original) ~= 'table' then
    return original
  end

  local copy = {}
  for key, value in pairs(original) do
    copy[key] = value
  end
  return copy
end

-- Like `require`, but re-run the contents of the module
function L.reload(package_name)
  package.loaded[package_name] = nil
  return require(package_name)
end

-- Join args together into a filepath
function L.join_paths(...)
  local separator = package.config:sub(1, 1)
  return table.concat({ ... }, separator)
end

local function knext(t, index)
  local value
  repeat
    index, value = next(t, index)
  until type(index) ~= 'number'
  return index, value
end

-- Iterate key/value pairs from a table, vs ipairs
function L.kpairs(t)
  return knext, t, nil
end

-- Shallow-copy a new table with only the integer indexed values
function L.itable(t)
  local it = {}
  for i, v in ipairs(t) do
    it[i] = v
  end
  return it
end

return L
