--[[----------------------------------------------------------------------------
Init

Installation notes:
- On first launch the `config.bootstrap` module will ask to download the
  package manager and setup anything needed for the config as a whole.
- Restart vim for the rest of the config to take effect.
- Run ':checkhealth' and make sure all necessary checks are green.
- See the `config.packages` module for notes on external dependencies.
------------------------------------------------------------------------------]]

-- Install package manager, configure preliminaries
if require('config.bootstrap').first_time_setup() then
  return
end

-- Configure built-in vim features
require('config.options').setup()

-- Enable packages and package-specific settings
require('config.packages').setup()

-- Global visual settings such as theme and statusline
require('config.ui').setup()

-- General purpose mappings
require('config.mappings').setup()

-- Mappings under the leader key
require('config.leader_mappings').setup()

-- Custom text objects
require('config.text_objects').setup()

-- Custom commands
require('config.commands').setup()

-- finally, filetype specific settings may be sourced from `after/ftplugin`
