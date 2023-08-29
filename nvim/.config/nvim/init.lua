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

-- Apply the full config
require('em.config').setup()

-- filetype specific settings may be sourced from `after/ftplugin`
