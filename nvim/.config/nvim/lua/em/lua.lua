--[[----------------------------------------------------------------------------
Lua utilities
------------------------------------------------------------------------------]]

local L = {}

-- split string into a table for each `sep`, defaults to whitespace
function L.split_str(inputstr, sep)
  sep = sep or '%s'

  local t = {}
  for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
    table.insert(t, str)
  end
  return t
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

return L
