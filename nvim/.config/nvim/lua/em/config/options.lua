--[[----------------------------------------------------------------------------
Options

All the little things.
------------------------------------------------------------------------------]]

local Options = {}

local use_true_color = require('em.vim').can_support_true_color()

-- stylua: ignore
Options.config = {
  cursorline = true,                -- highlight current line
  showcmd = true,                   -- show command so far in status line
  showmatch = true,                 -- highlight matching brackets
  showmode = true,                  -- show current mode in command area
  showtabline = 2,                  -- always show the tabline
  number = true,                    -- line numbers on the left side
  numberwidth = 4,                  -- number column is always 4 characters wide
  expandtab = true,                 -- insert spaces when TAB is pressed
  tabstop = 2,                      -- render TABs using this many spaces
  shiftwidth = 2,                   -- indentation amount for < and > commands
  errorbells = false,               -- no beeps
  modeline = false,                 -- disable modeline
  termguicolors = use_true_color,   -- full colors for supported terminals
  ignorecase = true,                -- make searching case insensitive...
  smartcase = true,                 -- ...unless the query has capital letters
  wrap = false,                     -- don't wrap text, use 'cow' to toggle wrap
  list = true,                      -- highlight tabs and trailing spaces
  scrolloff = 3,                    -- show next 3 lines while scrolling
  sidescrolloff = 5,                -- show next 5 columns while side-scrolling
  splitbelow = true,                -- horizontal split under active window
  splitright = true,                -- vertical split to right of active window
  autowriteall = true,              -- auto write file when switching buffers
  backup = false,                   -- don't create file backups
  swapfile = true,                  -- swap files in '~/.local/share/nvim/swap/'
  undofile = true,                  -- undo files to '~/.local/share/nvim/undo/'
  keywordprg = ':WebSearch!',       -- 'K' searches online for the keyword
  shortmess = {                     -- abreviated messages
    f = true,                       --   "(3 of 5)" vs "(file 3 of 5)"
    i = false,                      --   "[noeol]" vs "[Incomplete last line]"
    l = false,                      --   "99L, 88C" vs "99 lines, 88 characters"
    m = true,                       --   "[+]" vs "[Modified]"
    n = true,                       --   "[New]" vs "[New File]"
    r = false,                      --   "[RO]" vs "[readonly]"
    w = false,                      --   "[w]" vs "written", "[a]" vs "appended"
    x = true,                       --   "[unix]" vs "[unix format]" etc
    o = true,                       --   combine write/read messages
    O = true,                       --   combine other read messages
    s = false,                      --   don't show "search hit BOTTOM" message
    t = false,                      --   truncate file message if too long
    T = false,                      --   truncate other messages
    W = false,                      --   don't give file written message
    A = false,                      --   don't give message when swap file found
    I = true,                       --   don't show intro message on start
    c = false,                      --   don't give completion menu messages
    q = false,                      --   "recording" vs "recording @a"
    F = true,                       --   don't give file info when editing file
    S = false,                      --   do not show search count "[1/5]"
  },
  listchars = {                     -- symbols for whitespace characters
    tab = '>·',                     --   all tabs
    trail = '·'                     --   trailing spaces
  },
  wildmode = {                      -- command mode completion with popup menu
    'longest',                      --   TODO
    'full',                         --   TODO
  },
  fillchars = {                     -- characters to fill parts of UI
    vert = '▐',                     --   vertical bar to divide windows
    eob = ' ',                      --   no ~ at end of buffer
  },
  completeopt = {                   -- insert mode completion menu
    'menuone',                      --   show menu when there's one match
    'noselect',                     --   do not auto-select first match
  },
  matchpairs = {                    -- highlight matching pairs
    '(:)','{:}', '[:]', '<:>',      --   add angle brackets
  },
}

function Options.setup()
  for o, val in pairs(Options.config) do
    vim.opt[o] = val
  end
end

function Options.reload()
  return require('em.lua').reload('em.config.options')
end

return Options
