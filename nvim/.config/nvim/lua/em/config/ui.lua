--[[----------------------------------------------------------------------------
UI

Picking a theme requires knowing the color pallet limits of your terminal
emulator. Some terminals are limited to 16 or 256 colors, while 'true color'
terminals have the full hex color range. Counterintuitive, true color terminals
tend to set $TERM to 'xterm-256color', even though more than 256 colors are
available. The `can_support_true_color` test might need to be updated to
include or exclude regularly used terminals.

Use something close to the default statusline, with the addition of indicating
the current git branch (requires fugitive) and showing linting results
(requires ALE).
------------------------------------------------------------------------------]]

local UI = {}

-- stylua: ignore
local statusline = {
  '%{expand("%:~:.")}',   -- filepath relative to cwd
  '%(%1(%)%h%q%w%m%r%)',  -- tags: help, quickfix, preview, modified, read only
  '%<',                   -- truncate point
  '%=',                   -- right align
  '%1(%l,%c%)%5p%%',      -- line and col number, % through file
}

-- stylua: ignore
local tabline = {
  '%#TabLine#',                         -- highlight for content
  '%{%v:lua.em.tabline.tab_list()%}',   -- tab page list
  '%#TabLineFill#',                     -- highlight for empty space
  '%=',                                 -- right align
  '%#TabLine#',                         -- highlight for content
  '%{v:lua.em.tabline.lsp_servers()}',  -- running language servers
  '%(%5(%)%{getcwd()}%)',               -- current working directory
  '%(%1(%)[%{fugitive#Head()}]%)',      -- git info for cwd
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
  tabline = tabline,
  highlight_overrides = function()
    if vim.opt.termguicolors:get() then
      local fn = require('em.fn')
      fn.underline_spell_groups()
      fn.underline_lsp_groups()
      fn.always_show_win_seperator()
      fn.subtle_highlight_cursorline()
    end
  end,
}

function UI.setup()
  if vim.opt.termguicolors:get() then
    vim.opt.background = UI.config.true_color_theme.background
    vim.cmd('colorscheme ' .. UI.config.true_color_theme.colorscheme)
    vim.cmd([[highlight IndentBlanklineIndent1 guibg=#222436 gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent2 guibg=#1e202f gui=nocombine]])
  else
    vim.opt.background = UI.config.fallback_theme.background
    vim.cmd('colorscheme ' .. UI.config.fallback_theme.colorscheme)
  end

  vim.opt.statusline = table.concat(UI.config.statusline)
  vim.opt.tabline = table.concat(UI.config.tabline)
end

function UI.reload()
  return require('em.lua').reload('em.config.ui')
end

return UI
