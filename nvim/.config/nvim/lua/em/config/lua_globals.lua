--[[----------------------------------------------------------------------------
Global Lua Functions

Add functions to the lua environment, which is stored in the global variable
`_G`. This allows us to use the functions without an import, and makes it
easier to call functions from vim via `v:lua.em.global_function()`. We use this
technique in places where lua is not yet fully supported, such as the tabline.
------------------------------------------------------------------------------]]

local LuaGlobals = {}

LuaGlobals.config = {
  fn = require('em.fn'),
  lsp = require('em.lsp'),
  lua = require('em.lua'),
  tabline = require('em.tabline'),
  vim = require('em.vim'),
}

function LuaGlobals.setup()
  _G.em = LuaGlobals.config
end

function LuaGlobals.reload()
  return require('em.lua').reload('em.config.lua_globals')
end

return LuaGlobals
