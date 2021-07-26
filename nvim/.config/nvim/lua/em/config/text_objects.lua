--[[----------------------------------------------------------------------------
Text Objects

Note that the 's' sentence text object have been re-mapped to 'S', and the
original bindings have been repurposed for variable segments/sections.
------------------------------------------------------------------------------]]

-- i{*}             inner/inside text object
-- a{*}             a/all of text object, includes surrounding whitespace
--   c              comment
--   e              entire buffer
--   l              line
--   p              paragraph
--   s              variable segment, either snake_case or camelCase
--   S              sentence
--   t              html tags
--   w              word
--   W              WORD
--   [ or ], ( or ),
--   < or >, { or } matching pairs
--   `, ", '        matching quotes

local TextObjects = {}

TextObjects.config = {
  iS = { 'is', 'inner sentence' },
  aS = { 'as', 'a sentance (with whitespace)' },
  is = { '<Plug>CamelCaseMotion_iw', 'variable segment' },
  as = { '<Plug>CamelCaseMotion_iw', 'variable segment' },
}

function TextObjects.setup()
  local mappings = {}
  for k, m in pairs(TextObjects.config) do
    mappings['xo ' .. k] = m
  end

  require('em.vim').map(mappings)
end

function TextObjects.reload()
  return require('em.lua').reload('em.config.text_objects')
end

return TextObjects
