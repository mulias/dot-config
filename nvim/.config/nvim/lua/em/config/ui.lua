--[[----------------------------------------------------------------------------
UI

Picking a theme requires knowing the color pallet limits of your terminal
emulator. Some terminals are limited to 16 or 256 colors, while 'true color'
terminals have the full hex color range. Counterintuitive, true color terminals
tend to set $TERM to 'xterm-256color', even though more than 256 colors are
available. The `can_spport_true_color` test might need to be updated to include or
exclude regularly used terminals.

Use something close to the default statusline, with the addition of indicating
the current git branch (requires fugitive) and showing linting results
(requires ALE).
------------------------------------------------------------------------------]]

local UI = {}

-- stylua: ignore
local statusline = {
  '%f',                        -- full filepath
  '%1(%)',                     -- padding
  '%h%q%w',                    -- tags: help, quickfix, preview
  '%m%r',                      -- tags: modified, read only
  '%<',                        -- truncate point
  '%3(%)',                     -- padding
  '%=',                        -- right align
  '%12(%l,%c%)%5p%%'           -- line and col number, % through file
}

UI.config = {
  true_color_theme = {
    background = 'dark',
    colorscheme = 'moonlight',
  },
  fallback_theme = {
    background = 'light',
    colorscheme = 'paramount',
  },
  statusline = statusline,
  tabline = "%!v:lua.require'em.tabline'()",
}

function UI.setup()
  if vim.opt.termguicolors:get() then
    -- Set some general preferences after the colorscheme is applied. Only
    -- works for gui colors.
    -- * Use underlines instead of undercurls
    -- * Always show the vertical split line between buffers
    -- * Don't show tildas in empty space after the buffer
    -- * Don't highlight line background for cursorline, just the line number
    -- * When cursorline is enabled highlight the line number but not the
    --   content.
    require('em.vim').augroup('colorscheme_preferences', {
      {
        'ColorScheme *',
        table.concat({
          'lua local fn = require("em.fn")',
          'fn.underline_spell_groups()',
          'fn.always_show_vert_split()',
          'fn.hide_end_of_buffer_symbols()',
          'fn.subtle_highlight_cursorline()',
        }, '; '),
      },
    })
    vim.opt.background = UI.config.true_color_theme.background
    vim.cmd('colorscheme ' .. UI.config.true_color_theme.colorscheme)
  else
    vim.opt.background = UI.config.fallback_theme.background
    vim.cmd('colorscheme ' .. UI.config.fallback_theme.colorscheme)
  end

  vim.opt.statusline = table.concat(UI.config.statusline)
  vim.opt.tabline = UI.config.tabline
end

function UI.reload()
  return require('em.lua').reload('em.config.ui')
end

return UI
