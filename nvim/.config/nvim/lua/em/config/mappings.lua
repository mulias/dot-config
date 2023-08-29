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
  ['nx C'] = { '"_c', 'change text, do not save to register' },
  ['nx CC'] = { '"_cc', 'change line, do not save to register' },
  co = {
    name = 'toggle options',
    b = { 'yob', 'toggle background', noremap = false, silent = false },
    f = {
      require('em.fn').toggle_format_on_write,
      'toggle format on write',
      silent = false,
    },
    h = { 'yoh', 'toggle search highlight', noremap = false, silent = false },
    i = {
      require('indent_blankline.commands').toggle,
      'toggle indent guides',
      silent = false,
    },
    n = { 'yon', 'toggle line numbers', noremap = false, silent = false },
    r = {
      'yor',
      'toggle relative line numbers',
      noremap = false,
      silent = false,
    },
    s = { 'yos', 'toggle spellcheck', noremap = false, silent = false },
    w = { 'yow', 'toggle line wrap', noremap = false, silent = false },
    y = {
      require('em.fn').toggle_highlight_yank,
      'toggle highlight on yank',
      silent = false,
    },
    ['|'] = {
      require('em.fn').toggle_color_columns,
      'toggle color columns',
    },
    ['-'] = { 'yo-', 'toggle cursorline', noremap = false, silent = false },
    ['='] = {
      require('em.fn').toggle_window_resize,
      'toggle window auto-resize',
      silent = false,
    },
  },
  ['nx cx'] = {
    name = 'change case',
    c = { 'to camelCase' },
    C = { 'to CamelCase' },
    s = { 'to snake_case' },
    S = { 'to SNAKE_CASE' },
    k = { 'to kabab-Case' },
    K = { 'to Kabab-Case' },
    d = { 'to dot.case' },
    D = { 'to DOT.CASE' },
    w = { 'to word case' },
    W = { 'to WORD CASE' },
    t = { 'to Title Case' },
    l = { 'gu', 'to lowercase' },
    U = { 'gU', 'to UPPERCASE' },
  },
  yo = 'which_key_ignore',

  -- d{motion}        delete text
  -- dd               delete line
  -- ds{c}            delete surrounding chars {c}
  -- D{motion}        delete text, do not save to register
  -- DD               delete line, do not save to register
  ['nx D'] = { '"_d', 'delete text, do not save to register' },
  ['nx DD'] = { '"_dd', 'delete line, do not save to register' },

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
  g = {
    name = 'misc/variant',
    b = { '<Cmd>Git blame<CR>', 'view fugitive git blame annotations' },
    l = { 'V]e', 'swap current line with below', noremap = false },
    L = { 'V[e', 'swap current line with above', noremap = false },
    m = { '<Cmd>MagitOnly<CR>', 'open magit in current window' },
    s = { 'z=', 'show spelling suggestions' },
  },
  ['nx gp'] = { '"+p`]', 'paste from system clipboard' },
  ['nx gP'] = { '"+P', 'paste from system clipboard' },
  ['n gy'] = { '"+y', 'yank to system clipboard' },
  ['x gy'] = { '"+y`]', 'yank to system clipboard' },

  -- h                left
  -- H                left 3 columns
  -- <A-h>            previous buffer
  -- {Term}<A-h>      previous buffer
  -- <C-h>            focus window left
  -- {Term}<C-h>      focus window left
  ['nxo H'] = { 'hhh', 'left 3 columns' },
  ['n <A-h>'] = { '<Cmd>bprevious<CR>', 'previous buffer' },
  ['t <A-h>'] = { tc('<C-\\><C-n>:bprevious<CR>'), 'previous buffer' },
  ['n <C-h>'] = { '<C-w>h', 'focus window left' },
  ['i <C-h>'] = { '<ESC><C-w>h', 'focus window left, leave insert mode' },
  ['t <C-h>'] = { tc('<C-\\><C-n><C-w>h'), 'focus window let' },

  -- i                insert before cursor
  -- I                insert at beginning of line
  -- {VisualBlock}I   insert at beginning of each line in selection

  -- j                down
  -- J                down 3 lines
  -- <C-j>            focus window below
  -- {Term}<C-j>      focus window below
  -- {Visual}<C-j>    move selection down one line
  ['nxo J'] = { 'jjj', 'down 3 lines' },
  ['n <C-j>'] = { '<C-w>j', 'focus window below' },
  ['i <C-j>'] = { '<ESC><C-w>j', 'focus window below, leave insert mode' },
  ['x <C-j>'] = { ":m '>+1<CR>gv=gv", 'move selection down one line' },
  ['t <C-j>'] = { tc('<C-\\><C-n><C-w>j'), 'focus window below' },

  -- k                up
  -- K                up 3 lines
  -- <C-k>            focus window above
  -- {Term}<C-k>      focus window above
  -- {Insert}<C-k>    insert a diagraph (e.g. 'e' + ':' = 'ë')
  -- {Visual}<C-k>    move selection up one line
  ['nxo K'] = { 'kkk', 'up 3 lines' },
  ['n <C-k>'] = { '<C-w>k', 'focus window above' },
  ['i <C-k>'] = { '<ESC><C-w>k', 'focus window above, leave insert mode' },
  ['x <C-k>'] = { ":m '<-2<CR>gv=gv", 'move selection up one line' },
  ['t <C-k>'] = { tc('<C-\\><C-n><C-w>k'), 'focus window above' },

  -- l                right
  -- L                right 3 columns
  -- <A-l>            next buffer
  -- {Term}<A-l>      next buffer
  -- <C-l>            focus window right
  -- {Insert}<C-l>    focus window right, leave insert mode
  -- {Term}<C-l>      focus window right
  ['nxo L'] = { 'lll', 'right 3 columns' },
  ['<A-l>'] = { '<Cmd>bnext<CR>', 'next buffer' },
  ['n <C-l>'] = { '<C-w>l', 'focus window right' },
  ['i <C-l>'] = { '<ESC><C-w>l', 'focus window right, leave insert mode' },
  ['t <A-l>'] = { tc('<C-\\><C-n>:bnext<CR>'), 'next buffer' },
  ['t <C-l>'] = { tc('<C-\\><C-n><C-w>l'), 'focus window right' },

  -- m{a-Z}           set mark char, where a-z marks in buffer, A-Z cross-buffers
  -- M                jump middle, move cursor to middle line
  -- mm               set mark M (jump with <Leader>m)
  -- mn               set mark N (jump with <Leader>n)
  m = {
    name = 'set mark',
    m = { 'mM', 'set mark M' },
    n = { 'mN', 'set mark N' },
  },

  -- n                jump to next search result
  -- N                jump to previous search result

  -- o                insert line below cursor
  -- O                insert line above cursor
  -- {Insert}<C-o>    execute one command then return to insert mode

  -- p                put/paste after cursor, place cursor at end of pasted text
  -- {Visual}p        put/paste over selection, place cursor at end of pasted text
  -- P                paste before cursor
  ['nx p'] = { 'p`]', 'paste after cursor' },

  -- q{c}             record macro to register {c}
  -- @{c}             run macro from register {c}
  -- Q                run @q macro
  ['nxo Q'] = { '@q', 'run @q macro' },

  -- r                replace single character
  -- R                enter replace mode

  -- s                move forward by one camelCase or under_score word section
  -- S                move backwards by one camelCase or under_score word section
  -- {*}s and {*}S    surround actions
  --   cs{c1}{c1}     change surrounding chars from {c1} to {c2}
  --   ds{c}          delete surrounding chars {c}
  --   ys{motion}{c}  add new surrounding chars {c}
  --   {Visual}vs{c}  surround visual selection with {c}
  ['nxo s'] = {
    '<Plug>CamelCaseMotion_w',
    'move forward a section',
    noremap = false,
  },
  ['nxo S'] = {
    '<Plug>CamelCaseMotion_b',
    'move backwards a section',
    noremap = false,
  },

  -- t{c}             find 'til {c} forward
  -- T{c}             find 'til {c} backwards
  -- t                repeat last f/F/t/T motion forward
  -- T                repeat last f/F/t/T motion backward

  -- u                undo
  -- {Visual}u        lowercase selection
  -- U                redo
  -- {Visual}U        uppercase selection
  U = { '<C-r>', 'redo' },

  -- v                enter visual mode
  -- {Visual}vs{c}    surround visual selection with {c}
  -- V                enter visual line mode
  -- <C-v>            enter blockwise visual mode
  -- {Insert}<C-v>    insert a character literal (e.g. <TAB> instead of 2 spaces)
  ['x vs'] = { '<Plug>VSurround', 'surround visual selection' },

  -- w                move word forward
  -- W                move WORD forward

  -- x                delete char forward, don't save to register
  -- X                delete char backward, don't save to register
  -- <C-x>            decrement number under cursor (pairs with <C-a>)
  ['nx x'] = { '"_x', 'delete char forward' },
  ['nx X'] = { '"_X', 'delete char backwards' },

  -- y                yank/copy text
  -- {Visual}y        yank selection, place cursor at end of selection
  -- ys{motion}{c}    add new surrounding chars {c}
  -- Y                join lines (Y looks like two lines joining into one)
  ['x y'] = { 'y`]', 'yank/copy text' },
  ['nx Y'] = { 'J', 'join lines' },

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
  ['[e'] = { 'g;', 'previous change list entry' },
  [']e'] = { 'g,', 'next change list entry' },
  ['[j'] = { '<C-o>', 'previous jump list location' },
  [']j'] = { '<C-i>', 'next jump list location' },
  ['<A-[>'] = { '<C-o>', 'previous jump list location' },
  ['<A-]>'] = { '<C-i>', 'next jump list location' },
  ['<C-]>'] = { 'g<C-]>', 'follow ctag' },

  -- 0                go to first character of line
  -- ^                go to start of line
  -- $                go to end of line
  ['nxo 0'] = { '^', 'go to first character of line' },
  ['nxo ^'] = { '0', 'go to start of line' },

  -- %                jump to matching brace/bracket/paren

  -- :                enter command mode
  -- ;                enter command mode
  ['nxo ;'] = { ':', 'enter command mode', silent = false },

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
  ['x .'] = { '<Cmd>norm.<CR>', 'repeat last command' },

  -- -                open Dirvish in file's directory
  -- {Dirvish}-       move up to the parent directory
  -- {Dirvish}q       return to buffer dirvish was called from
  -- {Dirvish}<CR>    go to directory/edit file under cursor

  -- <Tab>            indent line/selection
  -- <S-Tab>          un-indent line/selection
  -- {Insert}<Tab>    show completion menu, scroll down through menu
  -- {Insert}<S-Tab>  if the completion menu is open scroll up, else insert a tab
  ['n <Tab>'] = { '>>', 'indent line' },
  ['n <S-Tab>'] = { '<<', 'un-indent line' },
  ['x <Tab>'] = { '>', 'indent selection' },
  ['x <S-Tab>'] = { '<', 'un-indent selection' },
  ['i <Tab>'] = {
    tc('pumvisible() ? "<C-n>" : compe#complete()'),
    'show/scroll completion menu',
    expr = true,
  },
  ['i <S-Tab>'] = {
    tc('pumvisible() ? "<C-p>" : "<Tab>"'),
    'scroll up through completion menu',
    expr = true,
  },
  ['<Esc>'] = {
    '<Esc>hl',
    'Return to normal mode, clear highlights and close floating windows',
  },
}

function Mappings.setup()
  require('em.vim').map(Mappings.config)
end

function Mappings.reload()
  return require('em.lua').reload('em.config.mappings')
end

return Mappings
