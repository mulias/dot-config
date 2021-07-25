--[[----------------------------------------------------------------------------
Commands

Notes on useful builtin and plugin commands:

Paq starts with ':Paq*', includes Install, Clean, Update, Upgrade.

Git starts with ':G*', includes blame, diff. Use ':GV' to view git history.

Unix utilities include ':Move', ':Rename', ':Delete', ':Mkdir'. Note that
':SudoEdit' and ':SudoWrite' are broken in nvim.

Rails
':Rpreview' open webpage, ':A' edit 'alternate' file (usually test)
':R' edit 'related' file (depends), editing specific files starts with ':E*'

Linting starts with ':ALE*', includes Lint, Toggle, Detail, Info.

Search/Replace
':Search' opens the prompt window to enter a search pattern, and ':Replace
newStr' replaces all instances of the pattern with the new value.

FZF
':Files [PATH]'      Files
':GFiles [OPTS]'     Git files
':GFiles?'           Git files
':Buffers'           Open buffers
':Colors'            Color schemes
':Ag [PATTERN]'      ag search result
':Rg [PATTERN]'      rg search result
':Lines [QUERY]'     Lines in loaded buffers
':BLines [QUERY]'    Lines in the current buffer
':Tags [QUERY]'      Tags in the project
':BTags [QUERY]'     Tags in the current buffer
':Marks'             Marks
':Windows'           Windows
':Locate PATTERN'    `locate` command output
':History'           `v:oldfiles` and open buffers
':History:'          Command history
':History/'          Search history
':Commits'           Git commits
':BCommits'          Git commits for the current buffer
':Commands'          Commands
':Maps'              Normal mode mappings
':Helptags'          Help tags
':Filetypes'         File types
------------------------------------------------------------------------------]]

local Commands = {}

Commands.config = {
  -- Highlight the color column, defaults to col 81 if nothing else is set
  TCC = { require('em.fn').toggle_color_columns },

  -- Toggle Neoformat so that it doesn't run on every save
  NeoformatToggle = { require('em.fn').neoformat_toggle },

  -- Run Neoformat as long as NeoformatToggle has not disabled it
  NeoformatIfEnabled = { require('em.fn').neoformat_if_enabled },

  -- Use suda to replace ':SudoEdit' and ':SudoWrite'
  SudoEdit = { 'SudaRead <args>', nargs = '?' },
  SudoWrite = { 'SudaWrite <args>', nargs = '?' },

  -- Manage plugins with packer, forcing a reload of plugins config
  -- Node: outer function ensures the reload happens every time, instead on
  -- once on command creation
  PackerCompile = {
    function()
      require('em.config.packages').reload().manage().compile()
    end,
  },
  PackerInstall = {
    function()
      require('em.config.packages').reload().manage().install()
    end,
  },
  PackerUpdate = {
    function()
      require('em.config.packages').reload().manage().update()
    end,
  },
  PackerClean = {
    function()
      require('em.config.packages').reload().manage().clean()
    end,
  },
  PackerSync = {
    function()
      require('em.config.packages').reload().manage().sync()
    end,
  },
}

function Commands.setup()
  for cmd_name, cmd in pairs(Commands.config) do
    require('em.vim').cmd(cmd_name, cmd[1], cmd)
  end
end

function Commands.reload()
  return require('em.lua').reload('em.config.commands')
end

return Commands
