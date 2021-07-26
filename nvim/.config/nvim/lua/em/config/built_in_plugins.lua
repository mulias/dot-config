--[[----------------------------------------------------------------------------
Built In Plugins
------------------------------------------------------------------------------]]

local BuiltInPlugins = {}

BuiltInPlugins.config = {
  man = true,
  matchparen = true,
  shada_plugin = true,
  gzip = false,
  matchit = false,
  tarPlugin = false,
  tar = false,
  zipPlugin = false,
  zip = false,
  netrwPlugin = false,
  tutor_mode_plugin = false,
  ['2html_plugin'] = false,
}

function BuiltInPlugins.setup()
  for plugin,enable in pairs(BuiltInPlugins.config) do
    if not enable then
      require('em.vim').disable_built_in_plugin(plugin)
    end
  end
end

function BuiltInPlugins.reload()
  return require('em.lua').reload('em.config.built_in_plugins')
end

return BuiltInPlugins
