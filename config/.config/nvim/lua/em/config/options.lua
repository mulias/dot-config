--[[----------------------------------------------------------------------------
Options

All the little things.
------------------------------------------------------------------------------]]

local Options = {}

-- path for file backups, should be '~/.local/share/nvim/backup/'
local backupdir = vim.fn.stdpath('data') .. '/backup/'

local is_true_color = require('em.vim').is_true_color_term()

-- stylua: ignore
Options.config = {
  showcmd = true,                   -- show command so far in status line
  showmatch = true,                 -- highlight matching brackets
  showmode = true,                  -- show current mode in command area
  number = true,                    -- line numbers on the left side
  numberwidth = 4,                  -- number column is always 4 characters wide
  expandtab = true,                 -- insert spaces when TAB is pressed
  tabstop = 2,                      -- render TABs using this many spaces
  shiftwidth = 2,                   -- indentation amount for < and > commands
  errorbells = false,               -- no beeps
  modeline = false,                 -- disable modeline
  termguicolors = is_true_color,    -- full colors for supported terminals
  joinspaces = false,               -- prevents extra spaces on a join (Y)
  ignorecase = true,                -- make searching case insensitive
  smartcase = true,                 -- ... unless the query has capital letters
  wrap = false,                     -- don't wrap text, use 'cow' to toggle wrap
  list = true,                      -- highlight tabs and trailing spaces
  listchars = "tab:>·,trail:·",     -- symbols for tabs and trailing spaces
  scrolloff = 3,                    -- show next 3 lines while scrolling
  sidescrolloff = 5,                -- show next 5 columns while side-scrolling
  splitbelow = true,                -- horizontal split under active window
  splitright = true,                -- vertical split to right of active window
  shortmess = "filnxtToOFI",        -- Don't show the intro
  bufhidden = "hide",               -- allow switching from an unsaved buffer
  autowriteall = true,              -- auto write file when switching buffers
  wildmode = "longest,full",        -- command mode completion with popup menu
  fillchars = "vert:▐",             -- use vertical bars to divide windows
  completeopt = "menuone,preview",  -- show completion menu for a single option
  matchpairs = "(:),{:},[:],<:>",   -- highlight matching angle brackets
  backup = false,                   -- don't create file backups...
  backupdir = backupdir,            -- ...but if they are created use this dir
  swapfile = true,                  -- swap files in '~/.local/share/nvim/swap/'
  undofile = true,                  -- undo files to '~/.local/share/nvim/undo/'
}

function Options.setup()
  for o, val in pairs(Options.config) do
    vim.opt[o] = val
  end

  -- unlike with swap, undo, and shada, nvim won't auto-mkdir for backups
  if not vim.fn.isdirectory(vim.fn.expand(backupdir)) then
    vim.fn.mkdir(vim.fn.expand(backupdir), 'p')
  end
end

function Options.reload()
  return require('em.lua').reload('em.config.options')
end

return Options
