--[[----------------------------------------------------------------------------
Init

Installation notes:
- On first launch the `em.bootstrap` module will ask to download the
  package manager and setup anything needed for the config as a whole.
- Restart vim for the rest of the config to take effect.
- Run ':checkhealth' and make sure all necessary checks are green.
- See the `em.config.packages` module for notes on external dependencies.
------------------------------------------------------------------------------]]

-- Install package manager, configure preliminaries
if require('em.bootstrap').first_time_setup() then
  return
end

-- Configure built-in vim features
require('em.config.options').setup()

-- Enable packages and package-specific settings
require('em.config.packages').setup()

-- Global visual settings such as theme and statusline
require('em.config.ui').setup()

-- General purpose mappings
require('em.config.mappings').setup()

-- Mappings under the leader key
require('em.config.leader_mappings').setup()

-- Custom text objects
require('em.config.text_objects').setup()

-- Custom commands
require('em.config.commands').setup()

-- finally, filetype specific settings may be sourced from `after/ftplugin`
