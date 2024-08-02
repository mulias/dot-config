--[[----------------------------------------------------------------------------
String manipulation utilities
------------------------------------------------------------------------------]]

local M = {}

local cs = require('coerce.string')
local cc = require('coerce.case')

--- Converts a keyword into KEBAB-CASE.
M.to_kebab_upper_case = function(str)
  local parts = cc.split_keyword(str)
  parts = vim.tbl_map(vim.fn.toupper, parts)
  return table.concat(parts, '-')
end

--- Converts a keyword into DOT.CASE.
M.to_dot_upper_case = function(str)
  local parts = cc.split_keyword(str)
  parts = vim.tbl_map(vim.fn.toupper, parts)
  return table.concat(parts, '.')
end

--- Converts a keyword into word case.
M.to_word_case = function(str)
  local parts = cc.split_keyword(str)
  return table.concat(parts, ' ')
end

--- Converts a keyword into WORD CASE.
M.to_word_upper_case = function(str)
  local parts = cc.split_keyword(str)
  parts = vim.tbl_map(vim.fn.toupper, parts)
  return table.concat(parts, ' ')
end

--- Converts a keyword into Word Case.
M.to_title_case = function(str)
  local parts = cc.split_keyword(str)

  for i = 1, #parts, 1 do
    local part_graphemes = cs.str2graphemelist(parts[i])
    part_graphemes[1] = vim.fn.toupper(part_graphemes[1])
    parts[i] = table.concat(part_graphemes, '')
  end

  return table.concat(parts, ' ')
end

return M
