--[[----------------------------------------------------------------------------
Built In Plugins

Nvim ships with a number of default vimscript plugins, which are generally
enabled by default. We can explicitly disable these plugins if desired.
Disabling the netrw plugin is particularly helpful, since it prevents some edge
cases where netrw would open instead of dirvish.
------------------------------------------------------------------------------]]

local BuiltInPlugins = {}

-- stylua: ignore
BuiltInPlugins.config = {
  matchparen = true,          -- highlight matching parens
  shada_plugin = true,        -- shared data file
  man = false,                -- manpages in vim
  spellfile_plugin = false,   -- download missing language files
  gzip = false,               -- edit gzip files
  matchit = false,            -- extra features for %
  tarPlugin = false,          -- edit tar files
  zipPlugin = false,          -- edit zip files
  netrwPlugin = false,        -- directory and network browser
  tutor_mode_plugin = false,  -- vim tutor
  ['2html_plugin'] = false,   -- convert vim window to HTML file
}

function BuiltInPlugins.setup()
  for plugin, enable in pairs(BuiltInPlugins.config) do
    if not enable then
      require('em.vim').disable_built_in_plugin(plugin)
    end
  end
end

function BuiltInPlugins.reload()
  return require('em.lua').reload('em.config.built_in_plugins')
end

return BuiltInPlugins
