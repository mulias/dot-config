--[[----------------------------------------------------------------------------
Config
------------------------------------------------------------------------------]]

local Config = {}

Config.config = {
  -- Extend lua global namespace
  'em.config.lua_globals',

  -- Configure built in vim features
  'em.config.options',

  -- Set which vim built in plugins should be allowed or disabled
  'em.config.built_in_plugins',

  -- Enable plugins and plugin-specific settings
  'em.config.plugins',

  -- General purpose mappings
  'em.config.mappings',

  -- Mappings under the leader key
  'em.config.leader_mappings',

  -- Custom text objects
  'em.config.text_objects',

  -- Custom commands
  'em.config.commands',

  -- Custom callback functions bound to vim events
  'em.config.autocommands',

  -- Global visual settings such as theme and statusline
  'em.config.ui',

  -- Language servers for diagnostics, linting, and formatting
  'em.config.lsp',
}

function Config.setup()
  local setup_feature = function(module)
    require(module).setup()
  end

  for _, feature in ipairs(Config.config) do
    local success, error_msg = pcall(setup_feature, feature)

    if not success then
      vim.notify(
        'Error loading ' .. feature .. ': ' .. error_msg,
        vim.log.levels.ERROR
      )
    end
  end
end

function Config.reload()
  local reload_feature = function(module)
    require(module).reload()
  end

  local reloaded = require('em.lua').reload('em.config')

  for _, feature in ipairs(reloaded.config) do
    local success, error_msg = pcall(reload_feature, feature)

    if not success then
      vim.notify(
        'Error reloading ' .. feature .. ': ' .. error_msg,
        vim.log.levels.ERROR
      )
    end
  end

  return reloaded
end

return Config
