--[[----------------------------------------------------------------------------
Commands

Notes on useful builtin and plugin commands:

Git starts with ':G*', includes blame, diff. Use ':GV' to view git history.

Unix utilities include ':Move', ':Rename', ':Delete', ':Mkdir'. Note that
':SudoEdit' and ':SudoWrite' are broken in nvim and have been redefined with a
different plugin.

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

local fn = require('em.fn')
local plugins = require('em.config.plugins')

Commands.config = {
  -- Highlight the color column, defaults to col 81 if nothing else is set
  ToggleColorColumn = { fn.toggle_color_columns },

  -- Use LSP to apply formatting to the current buffer
  Format = { fn.format_buffer },

  -- Toggle formatting on save
  ToggleFormat = { fn.toggle_format_on_write },

  -- Toggle windows auto-adjusting position and width
  ToggleWindowResize = { fn.toggle_window_resize },

  -- Toggle temporary highlighting when yanking text
  ToggleHighlightYank = { fn.toggle_highlight_yank },

  -- Use suda to replace ':SudoEdit' and ':SudoWrite'
  SudoEdit = { 'SudaRead <args>', nargs = '?' },
  SudoWrite = { 'SudaWrite <args>', nargs = '?' },

  -- Manage plugins with packer, forcing a reload of plugins config
  -- Note: thunk ensures the reload happens every time, instead on once on
  -- command creation
  PackerCompile = {
    function()
      plugins.reload().manage().compile()
    end,
  },
  PackerInstall = {
    function()
      plugins.reload().manage().install()
    end,
  },
  PackerUpdate = {
    function()
      plugins.reload().manage().update()
    end,
  },
  PackerClean = {
    function()
      plugins.reload().manage().clean()
    end,
  },
  PackerSync = {
    function()
      plugins.reload().manage().sync()
    end,
  },
}

function Commands.setup()
  for cmd_name, cmd in pairs(Commands.config) do
    require('em.vim').command(cmd_name, cmd[1], cmd)
  end
end

function Commands.reload()
  return require('em.lua').reload('em.config.commands')
end

return Commands
