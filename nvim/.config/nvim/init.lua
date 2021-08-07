--[[----------------------------------------------------------------------------
Init

Installation notes:
- On first launch the `em.bootstrap` module will ask to download the
  package manager and setup anything needed for the config as a whole.
- Restart vim for the rest of the config to take effect.
- Run ':checkhealth' and make sure all necessary checks are green.
- See the `em.config.plugins` module for notes on external dependencies.
------------------------------------------------------------------------------]]

-- Install plugin manager and plugins if needed
if require('em.bootstrap').first_time_setup() then
  return
end

-- Extend lua global namespace
require('em.config.lua_globals').setup()

-- Configure built in vim features
require('em.config.options').setup()

-- Set which vim built in plugins should be allowed or disabled
require('em.config.built_in_plugins').setup()

-- Enable plugins and plugin-specific settings
require('em.config.plugins').setup()

-- General purpose mappings
require('em.config.mappings').setup()

-- Mappings under the leader key
require('em.config.leader_mappings').setup()

-- Custom text objects
require('em.config.text_objects').setup()

-- Custom commands
require('em.config.commands').setup()

-- Custom callback functions bound to vim events
require('em.config.autocommands').setup()

-- Global visual settings such as theme and statusline
require('em.config.ui').setup()

-- Language servers for diagnostics, linting, and formatting
require('em.config.lsp').setup()

-- finally, filetype specific settings may be sourced from `after/ftplugin`
