--[[----------------------------------------------------------------------------
UI

Picking a theme requires knowing the color pallet limits of your terminal
emulator. Some terminals are limited to 16 or 256 colors, while 'true color'
terminals have the full hex color range. Counterintuitive, true color terminals
tend to set $TERM to 'xterm-256color', even though more than 256 colors are
available. The `is_true_color_term` test might need to be updated to include or
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
  '%([%{fugitive#head()}]%)',  -- git branch
  '%<',                        -- truncate point
  '%3(%)',                     -- padding
  -- [[%{luaeval('require("helpers").ale_status()')}]],        -- ALE errors/warnings, if any exist
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
}

function UI.setup()
  -- Some colorschemes use the 'undercurl' squiggly line, which can be
  -- distracting. This sets incorrect words and errors to use an underline
  -- instead.
  require('util.vim').augroup('no_undercurl', {
    {
      'ColorScheme',
      '*',
      table.concat({
        'highlight clear SpellBad',
        'highlight clear SpellCap',
        'highlight clear SpellRare',
        'highlight clear SpellLocal',
        'highlight SpellBad cterm=underline gui=underline',
        'highlight SpellCap cterm=underline gui=underline',
        'highlight SpellRare cterm=underline gui=underline',
        'highlight SpellLocal cterm=underline gui=underline',
      }, ' | '),
    },
  })

  if vim.opt.termguicolors then
    vim.opt.background = UI.config.true_color_theme.background
    vim.cmd('silent! colorscheme ' .. UI.config.true_color_theme.colorscheme)
  else
    vim.opt.background = UI.config.fallback.background
    vim.cmd('silent! colorscheme ' .. UI.config.fallback_theme.colorscheme)
  end

  vim.opt.statusline = table.concat(UI.config.statusline)
end

function UI.reload()
  return require('util.lua').reload('config.ui')
end

return UI
