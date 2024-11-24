--[[----------------------------------------------------------------------------
Mappings

Common editing commands and motions, listed in alphabetical order. Add a number
of keymaps and change a few defaults. Notable changes to default behavior
include:

C{motion}        change text, do not save to register
D{motion}        delete text, do not save to register
H                left 3 columns
J                down 3 lines
K                up 3 lines
L                right 3 columns
Q                execute the macro in register q
U                redo
x                delete char forward, don't save to register
X                delete char backward, don't save to register
Y                join two lines (Y looks like two lines joining into one)
;                enter command mode
0                go to first character of line
^                go to start of line
<Tab>            indent line
<S-Tab>          un-indent line
{Insert}<Tab>    open completion menu, or scroll down through menu
{Insert}<S-Tab>  if the completion menu is open scroll up, else insert a tab

In the config `['nxo foo'] = { ... }` means that the binding `foo` is applied
to normal, visual, and operator pending modes. When there is no mode prefix the
binding is applied to normal mode. See `:h map-modes` for mode abbreviations.
------------------------------------------------------------------------------]]

local Mappings = {}

local tc = require('em.vim').tc -- escape termcodes

Mappings.config = {
  -- a                insert after cursor
  -- A                insert at end of line
  -- <C-a>            increment number under cursor (pairs with <C-x>)

  -- b                move word backward
  -- B                move WORD backward

  -- c{motion}        change text
  -- cc               change line
  -- C{motion}        change text, do not save to register
  -- CC               change line, do not save to register
  -- co{*}            toggle options
  --   cof            toggle formatting on save
  --   coh            toggle hlsearch
  --   con            toggle line numbers
  --   cor            toggle relative line numbers
  --   cos            toggle spell check
  --   cow            toggle wrap
  --   co|            toggle color columns, or make a new one on line 81
  --   co-            toggle cursor line highlight
  -- cs{c1}{c1}       change surrounding chars from {c1} to {c2}
  -- cx{*}            change case with a motion or selection
  --   cxc            to camelCase
  --   cxC            to CamelCase
  --   cxs            to snake_case
  --   cxS            to SNAKE_CASE
  --   cxk            to kabab-case
  --   cxK            to KABAB-CASE
  --   cxd            to dot.case
  --   cxD            to DOT.CASE
  --   cxw            to word case
  --   cxW            to WORD CASE
  --   cxt            to Title Case
  --   cxl            to lowercase
  --   cxU            to UPPERCASE
  { 'C', '"_c', desc = 'change text, do not save to register', mode = { 'n', 'x' } },
  { 'CC', '"_cc', desc = 'change line, do not save to register', mode = { 'n', 'x' } },
  { 'co', group = 'toggle options' },
  { 'cob', 'yob', desc = 'toggle background', noremap = false, silent = false },
  {
    'cof',
    require('em.fn').toggle_format_on_write,
    desc = 'toggle format on write',
    silent = false,
  },
  { 'coh', 'yoh', desc = 'toggle search highlight', noremap = false, silent = false },
  -- {
  --   'coi',
  --   require('indent_blankline.commands').toggle,
  --   desc = 'toggle indent guides',
  --   silent = false,
  -- },
  { 'con', 'yon', desc = 'toggle line numbers', noremap = false, silent = false },
  { 'cor', 'yor', desc = 'toggle relative line numbers', noremap = false, silent = false },
  { 'cos', 'yos', desc = 'toggle spellcheck', noremap = false, silent = false },
  { 'cow', 'yow', desc = 'toggle line wrap', noremap = false, silent = false },
  {
    'coy',
    require('em.fn').toggle_highlight_yank,
    desc = 'toggle highlight on yank',
    silent = false,
  },
  { 'co|', require('em.fn').toggle_color_columns, desc = 'toggle color columns' },
  { 'co-', 'yo-', desc = 'toggle cursorline', noremap = false, silent = false },
  {
    'co=',
    require('em.fn').toggle_window_resize,
    desc = 'toggle window auto-resize',
    silent = false,
  },

  { 'cx', group = 'change case' },
  { 'cxc', desc = 'to camelCase', mode = { 'x', 'c' } },
  { 'cxC', desc = 'to CamelCase', mode = { 'x', 'c' } },
  { 'cxs', desc = 'to snake_case', mode = { 'x', 'c' } },
  { 'cxS', desc = 'to SNAKE_CASE', mode = { 'x', 'c' } },
  { 'cxk', desc = 'to kabab-case', mode = { 'x', 'c' } },
  { 'cxK', desc = 'to KABAB-CASE', mode = { 'x', 'c' } },
  { 'cxd', desc = 'to dot.case', mode = { 'x', 'c' } },
  { 'cxD', desc = 'to DOT.CASE', mode = { 'x', 'c' } },
  { 'cxw', desc = 'to word case', mode = { 'x', 'c' } },
  { 'cxW', desc = 'to WORD CASE', mode = { 'x', 'c' } },
  { 'cxt', desc = 'to Title Case', mode = { 'x', 'c' } },
  { 'cxn', desc = 'to numeronym (n7m)', mode = { 'x', 'c' } },
  { 'cxp', desc = 'to path/case', mode = { 'x', 'c' } },
  { 'cxl', 'gu', desc = 'to lowercase', mode = { 'x', 'c' } },
  { 'cxU', 'gU', desc = 'to LOWERCASE', mode = { 'x', 'c' } },

  -- d{motion}        delete text
  -- dd               delete line
  -- ds{c}            delete surrounding chars {c}
  -- D{motion}        delete text, do not save to register
  -- DD               delete line, do not save to register
  { 'D', '"_d', desc = 'delete text, do not save to register', mode = { 'n', 'x' } },
  { 'DD', '"_dd', desc = 'delete line, do not save to register', mode = { 'n', 'x' } },

  -- e                move to end of word
  -- E                move to end of WORD

  -- f{c}             find {c} forward
  -- F{c}             finds {c} backwards
  -- f                repeat last f/F/t/T motion forward
  -- F                repeat last f/F/t/T motion backward

  -- g{*}             misc/variant actions
  --   gc{motion}     toggle commenting on lines that {motion} moves over
  --   gcc            comment/uncomment line
  --   gf             edit file at filepath under cursor
  --   gg             jump to start of file, or line N for {N}gg
  --   gj             down through a wrapped text line
  --   gk             up through a wrapped text line
  --   gl             swap current line with line [count] below
  --   gL             swap current line with line [count] above
  --   gm             switch to magit in current buffer
  --   gp             paste from system clipboard, move cursor to end of pasted
  --   {Visual}gp     paste from system clipboard over selection, move to end
  --   gP             paste from system clipboard, put text before cursor
  --   gq             reformat/wrap text
  --   gs             give spelling suggestions
  --   gt             go to the next tabpage
  --   gT             go to the previous tabpage
  --   gu{motion}     lowercase
  --   gU{motion}     uppercase
  --   guu            lowercase line
  --   gUU            uppercase line
  --   gv             re-select last visual selection
  --   gy             yank to system clipboard
  --   {Visual}gy     yank selection to system clipboard
  --   gz             center window on cursor line
  --   g?             rot13 selection/motion
  --   g<C-]>         LSP goto definition
  -- G                jump to end of file
  { 'g', group = 'misc/variant' },
  { 'gb', '<Cmd>Git blame<CR>', desc = 'view fugitive git blame annotations' },
  { 'gl', 'V]e', desc = 'swap current line with below', noremap = false },
  { 'gL', 'V[e', desc = 'swap current line with above', noremap = false },
  { 'gm', '<Cmd>MagitOnly<CR>', desc = 'open magit in current window' },
  { 'gs', 'z=', desc = 'show spelling suggestions', noremap = false },
  { 'gp', '"+p`]', desc = 'paste from system clipboard', mode = { 'n', 'x' } },
  { 'gP', '"+P', desc = 'paste from system clipboard', mode = { 'n', 'x' } },
  { 'gy', '"+y', desc = 'yank to system clipboard' },
  { 'gy', '"+y`]', desc = 'yank to system clipboard', mode = 'x' },

  -- h                left
  -- H                left 3 columns
  -- <A-h>            previous buffer
  -- {Term}<A-h>      previous buffer
  -- <C-h>            focus window left
  -- {Term}<C-h>      focus window left
  { 'H', 'hhh', desc = 'left 3 columns', mode = { 'n', 'x', 'o' } },
  { '<A-h>', '<Cmd>bprevious<CR>', desc = 'previous buffer' },
  { '<A-h>', tc('<C-\\><C-n>:bprevious<CR>'), desc = 'previous buffer', mode = 't' },
  { '<C-h>', '<C-w>h', desc = 'focus window left' },
  { '<C-h>', '<ESC><C-w>h', desc = 'focus window left, leave insert mode', mode = 'i' },
  { '<C-h>', tc('<C-\\><C-n><C-w>h'), desc = 'focus window let', mode = 't' },

  -- i                insert before cursor
  -- I                insert at beginning of line
  -- {VisualBlock}I   insert at beginning of each line in selection

  -- j                down
  -- J                down 3 lines
  -- <C-j>            focus window below
  -- {Term}<C-j>      focus window below
  -- {Visual}<C-j>    move selection down one line
  { 'J', 'jjj', desc = 'down 3 lines', mode = { 'n', 'x', 'o' } },
  { '<C-j>', '<C-w>j', desc = 'focus window below' },
  { '<C-j>', '<ESC><C-w>j', desc = 'focus window below, leave insert mode', mode = 'i' },
  { '<C-j>', ":m '>+1<CR>gv=gv", desc = 'move selection down one line', mode = 'x' },
  { '<C-j>', tc('<C-\\><C-n><C-w>j'), desc = 'focus window below', mode = 't' },

  -- k                up
  -- K                up 3 lines
  -- <C-k>            focus window above
  -- {Term}<C-k>      focus window above
  -- {Insert}<C-k>    insert a diagraph (e.g. 'e' + ':' = 'ë')
  -- {Visual}<C-k>    move selection up one line
  { 'K', 'kkk', desc = 'up 3 lines', mode = { 'n', 'x', 'o' } },
  { '<C-k>', '<C-w>k', desc = 'focus window above' },
  { '<C-k>', '<ESC><C-w>k', desc = 'focus window above, leave insert mode', mode = 'i' },
  { '<C-k>', ":m '<-2<CR>gv=gv", desc = 'move selection up one line', mode = 'x' },
  { '<C-k>', tc('<C-\\><C-n><C-w>k'), desc = 'focus window above', mode = 't' },

  -- l                right
  -- L                right 3 columns
  -- <A-l>            next buffer
  -- {Term}<A-l>      next buffer
  -- <C-l>            focus window right
  -- {Insert}<C-l>    focus window right, leave insert mode
  -- {Term}<C-l>      focus window right
  { 'L', 'lll', desc = 'right 3 columns', mode = { 'n', 'x', 'o' } },
  { '<A-l>', '<Cmd>bnext<CR>', desc = 'next buffer' },
  { '<C-l>', '<C-w>l', desc = 'focus window right' },
  { '<C-l>', '<ESC><C-w>l', desc = 'focus window right, leave insert mode', mode = 'i' },
  { '<C-l>', tc('<C-\\><C-n>:bnext<CR>'), desc = 'next buffer', mode = 't' },
  { '<C-l>', tc('<C-\\><C-n><C-w>l'), desc = 'focus window right', mode = 't' },

  -- m{a-Z}           set mark char, where a-z marks in buffer, A-Z cross-buffers
  -- M                jump middle, move cursor to middle line
  -- mm               set mark M (jump with <Leader>m)
  -- mn               set mark N (jump with <Leader>n)
  { 'm', group = 'set mark' },
  { 'mm', 'mM', desc = 'set mark M' },
  { 'mn', 'mN', desc = 'set mark N' },

  -- n                jump to next search result
  -- N                jump to previous search result

  -- o                insert line below cursor
  -- O                insert line above cursor
  -- {Insert}<C-o>    execute one command then return to insert mode

  -- p                put/paste after cursor, place cursor at end of pasted text
  -- {Visual}p        put/paste over selection, place cursor at end of pasted text
  -- P                paste before cursor
  { 'p', 'p`]', desc = 'paste after cursor', mode = { 'n', 'x' } },

  -- q{c}             record macro to register {c}
  -- @{c}             run macro from register {c}
  -- Q                run @q macro
  { 'Q', '@q', desc = 'run @q macro', mode = { 'n', 'x', 'o' } },

  -- r                replace single character
  -- R                enter replace mode

  -- s                move forward by one camelCase or under_score word section
  -- S                move backwards by one camelCase or under_score word section
  -- {*}s and {*}S    surround actions
  --   cs{c1}{c1}     change surrounding chars from {c1} to {c2}
  --   ds{c}          delete surrounding chars {c}
  --   ys{motion}{c}  add new surrounding chars {c}
  --   {Visual}vs{c}  surround visual selection with {c}
  {
    's',
    '<Plug>CamelCaseMotion_w',
    desc = 'move forward a section',
    noremap = false,
    mode = { 'n', 'x', 'o' },
  },
  {
    'S',
    '<Plug>CamelCaseMotion_b',
    desc = 'move backwards a section',
    noremap = false,
    mode = { 'n', 'x', 'o' },
  },

  -- t{c}             find 'til {c} forward
  -- T{c}             find 'til {c} backwards
  -- t                repeat last f/F/t/T motion forward
  -- T                repeat last f/F/t/T motion backward

  -- u                undo
  -- {Visual}u        lowercase selection
  -- U                redo
  -- {Visual}U        uppercase selection
  { 'U', '<C-r>', desc = 'redo' },

  -- v                enter visual mode
  -- {Visual}vs{c}    surround visual selection with {c}
  -- V                enter visual line mode
  -- <C-v>            enter blockwise visual mode
  -- {Insert}<C-v>    insert a character literal (e.g. <TAB> instead of 2 spaces)
  { 'vs', '<Plug>VSurround', desc = 'surround visual selection', mode = 'x' },

  -- w                move word forward
  -- W                move WORD forward

  -- x                delete char forward, don't save to register
  -- X                delete char backward, don't save to register
  -- <C-x>            decrement number under cursor (pairs with <C-a>)
  { 'x', '"_x', desc = 'delete char forward', mode = { 'n', 'x' } },
  { 'X', '"_X', desc = 'delete char backwards', mode = { 'n', 'x' } },

  -- y                yank/copy text
  -- {Visual}y        yank selection, place cursor at end of selection
  -- ys{motion}{c}    add new surrounding chars {c}
  -- Y                join lines (Y looks like two lines joining into one)
  { 'y', 'y`]', desc = 'yank/copy text', mode = 'x' },
  { 'Y', 'J', desc = 'join lines', mode = { 'n', 'x' } },

  -- z{*}             manage folds
  --   zc             close fold
  --   zd             delete fold
  --   zf             create fold with motion
  --   zi             toggle all folds in buffer
  --   zo             open fold
  -- zz               center window on cursor
  -- ZZ               save and exit
  -- <C-z>            suspend program

  -- [{*}             back list entry actions
  --   [b, [B         previous, first buffer
  --   [d             previous lsp diagnostic entry
  --   [l, [L         previous, first location list entry
  --   [q, [Q         previous, first quickfix list entry
  --   [t, [T         previous, first tag stack entry
  --   [s             previous misspelled word
  --   [e             previous change list entry
  --   [j             previous jump list location
  -- ]{*}             forward list entry actions
  --   ]b, ]B         next, last buffer
  --   ]d             next lsp diagnostic entry
  --   ]l, ]L         next, last location list entry
  --   ]q, ]Q         next, last quickfix list entry
  --   ]t, ]T         next, last tag stack entry
  --   ]s             next misspelled word
  --   ]e             next change list entry
  --   ]j             next jump list location
  -- [y{motion}       encode string with c-style escape sequences
  -- ]y{motion}       decode string with c-style escape sequences
  -- [<space>         insert [count] blank line(s) above
  -- ]<space>         insert [count] blank line(s) below
  -- <A-[>            previous jump list location
  -- <A-]>            next jump list location
  -- <C-]>            follow ctag, list all tags if there is more than one match
  -- <C-[>            <ESC>
  { '[e', 'g;', desc = 'previous change list entry' },
  { ']e', 'g,', desc = 'next change list entry' },
  { '[j', '<C-o>', desc = 'previous jump list location' },
  { ']j', '<C-i>', desc = 'next jump list location' },
  { '<A-[>', '<C-o>', desc = 'previous jump list location' },
  { '<A-]>', '<C-i>', desc = 'next jump list location' },
  { '<C-]>', 'g<C-]>', desc = 'follow ctag' },

  -- 0                go to first character of line
  -- ^                go to start of line
  -- $                go to end of line
  { '0', '^', desc = 'go to first character of line', mode = { 'n', 'x', 'o' } },
  { '^', '0', desc = 'go to start of line', mode = { 'n', 'x', 'o' } },

  -- %                jump to matching brace/bracket/paren

  -- :                enter command mode
  -- ;                enter command mode
  { ';', ':', desc = 'enter command mode', mode = { 'n', 'x', 'o' }, silent = false },

  -- {                jump to beginning of paragraph
  -- }                jump to end of paragraph

  -- /                search
  -- ?                search backwards

  -- *                search for word under cursor forward
  -- {Visual}*        search for selection forward
  -- #                search for word under cursor backwards
  -- {Visual}#        search for selection backward

  -- >>               indent line
  -- {Visual}>        indent selection
  -- <<               un-indent line
  -- {Visual}<        un-indent selection
  -- ==               auto indent
  -- {Visual}=        auto indent selection

  -- "{r}{y/d/c/p}    use register {r} for next yank, delete, or paste
  -- "{r}{y/d/c/p}    store text to register {r} for next yank or delete
  -- ""               default register, '""y' is equivalent to 'y'
  -- "{a-z}           named registers for manual use
  -- "_               black hole/trash register
  -- ".               contains last inserted text
  -- "%               contains name of current file
  -- "#               contains name of alternate file
  -- ":               contains most recently executed command
  -- "/               contains last search

  -- '{a-Z}           jump to mark {a-Z}, start of line
  -- `{a-Z}           jump to mark {a-Z}, line and column position

  -- .                repeat last command
  -- {Visual}.        repeat last command once on each line
  { '.', '<Cmd>norm.<CR>', desc = 'repeat last command', mode = 'x' },

  -- -                open Dirvish in file's directory
  -- {Dirvish}-       move up to the parent directory
  -- {Dirvish}q       return to buffer dirvish was called from
  -- {Dirvish}<CR>    go to directory/edit file under cursor

  -- <Tab>            indent line/selection
  -- <S-Tab>          un-indent line/selection
  -- {Insert}<Tab>    show completion menu, scroll down through menu
  -- {Insert}<S-Tab>  if the completion menu is open scroll up, else insert a tab
  { '<Tab>', '>>', desc = 'indent line' },
  { '<S-Tab>', '<<', desc = 'un-indent line' },
  { '<Tab>', '>', desc = 'indent selection', mode = 'x' },
  { '<S-Tab>', '<', desc = 'un-indent selection', mode = 'x' },
  {
    '<Tab>',
    desc = 'show/scroll completion menu',
    mode = { 'i', 's' },
  },
  { '<S-Tab>', desc = 'scroll up through completion menu', mode = { 'i', 's' } },
  {
    '<Esc>',
    '<Esc>hl',
    desc = 'Return to normal mode, clear highlights and close floating windows',
  },
  { '<Down>', 'gj', desc = 'down through wrapped lines', mode = { 'n', 'x' } },
  { '<Down>', '<C-o>gj', desc = 'down through wrapped lines', mode = 'i' },
  { '<Up>', 'gk', desc = 'up through wrapped lines', mode = { 'n', 'x' } },
  { '<Up>', '<C-o>gk', desc = 'up through wrapped lines', mode = 'i' },
}

vim.api.nvim_set_keymap('i', '<Tab>', '', { callback = require('em.fn').tab_complete, expr = true })
vim.api.nvim_set_keymap('s', '<Tab>', '', { callback = require('em.fn').tab_complete, expr = true })
vim.api.nvim_set_keymap(
  'i',
  '<S-Tab>',
  '',
  { callback = require('em.fn').shift_tab_complete, expr = true }
)
vim.api.nvim_set_keymap(
  's',
  '<S-Tab>',
  '',
  { callback = require('em.fn').shift_tab_complete, expr = true }
)

function Mappings.setup()
  require('which-key').add(Mappings.config)
end

function Mappings.reload()
  return require('em.lua').reload('em.config.mappings')
end

return Mappings
