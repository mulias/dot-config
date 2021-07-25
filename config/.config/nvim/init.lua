--[[----------------------------------------------------------------------------
init.lua

Setup
* On first launch `packages.setup()` will ask to download the package manager
  and then install packages.
* Restart vim for the rest of the config to take effect.
* Run ':checkhealth' and make sure all necessary checks are green.
* FZF, SearchReplace: Install Ripgrep.
* Neoformat: Install formatters for regularly used languages.
* ALE: Install linters for regularly used languages. Use ':ALEInfo' on a file to
  find out about linting that file type.
* Gutentags: Install Universal Ctags.

Vim Compatibility
This config is only intended to work for neovim. If I only have access to
standard vim then I use a minimal config with the addition of the plugin
'tpope/vim-sensible'.

Documentation
The goal is to over-document, so that this file can act not only as a
configuration, but as a reference for learning/relearning vim features. I try to
use a notation that is consistent with or at least inspired by the notation used
in the vim docs, which is specified in ':help notation'. Special notation
includes:
* I use {c} to mean a single required character, and {*} to mean a single
  character, restricted to the list immediately following.
* When a key combination is specific to a mode or environment I preface it with
  {EnvName}. The docs use {Visual}, but I've added {Insert}, {FZF}, etc.
--]]

-- Try to load the package manager and make desired packages available
if not require('packages').setup() then
  -- Unable to complete setup, probably because it's a fresh install and
  -- requires a reboot.
  return
end

-- Local aliases for lua helpers
local packages = require('packages')   -- manage installed packages
local util = require('vim_utils')      -- lua wrappers for some vim features
local opt = util.opt                   -- set a single vim option
local opts = util.opts                 -- set many vim options

-- Make an autocmd group to use in this file. All autocmds should be bound to a
-- group to prevents repeated autocmd execution when this config is sourced.
local vimrc_group = util.augroup('vimrc', {})

--[[----------------------------------------------------------------------------
Packages
Load and configure packages/plugin.
--]]----------------------------------------------------------------------------

local packages = require('packages')

-- Manage packages
-- Make sure to run 'helptags ALL' after installing or updating packages.
packages.load('paq-nvim')

-- Helpers for configuring vim using lua.
packages.load('astronauta.nvim')
local key = require('astronauta.keymap')

-- Search and navigate with fuzzy find
-- Open fzf in a terminal buffer, with values loaded in from different sources.
-- <Leader>a        fzf search all text in project
-- <Leader>A        fzf search all text in project, full screen
-- <Leader>b        fzf search buffer list
-- <Leader>e        fzf search everything on disk (like ':e /foo/bar')
-- <Leader>f        fzf search file paths, insert selected file path into buffer
-- <Leader>gc       fzf search git commits
-- <Leader>gf       fzf search all files in current git repo (alias '<Leader>p')
-- <Leader>gh       fzf search git commits for buffer (buffer's git history)
-- <Leader>gs       fzf search `git status`, meaning files with unstaged changes
-- <Leader>h        fzf search recently opened files history
-- <Leader>p        fzf search project files, meaning files in root dir git repo
-- <Leader>z        fzf search ctags (ctag[z])
-- <Leader>Z        fzf search helptags (helptag[Z])
-- <Leader>/        fzf search text in current buffer
-- <Leader>*        fzf search text in current buffer for word under cursor
-- <Leader><TAB>    fzf search mappings in normal/visual/pending mode
-- {FZF}<TAB>       select multiple results to open
-- {FZF}<C-t>       open in new tab
-- {FZF}<C-s>       open in horizontal split
-- {FZF}<C-v>       open in vertical split
packages.load('fzf')
packages.load('fzf.vim')
vim.g.fzf_action = {
  ['ctrl-t'] = 'tab split',
  ['ctrl-s'] = 'split',
  ['ctrl-v'] = 'vsplit'
}
vim.g.fzf_layout = { down = '40%' }

-- TODO
packages.load('popup.nvim')
packages.load('plenary.nvim')
packages.load('telescope.nvim')

-- Formatting
-- Find and run code formatters on buffer write. Neoformat automatically
-- searches for global executables, but not project-local ones. I've added a
-- prettier config for JS and TS that checks node_modules first, then falls back
-- on a global prettier install.
-- cof                                enable/disable formatting on save
-- :Neoformat [formatter]             run formatting on the current buffer
-- {Visual}:Neoformat [formatter]     run formatting on selection
packages.load('neoformat')
vim.g.neoformat_basic_format_retab = 1
vim.g.neoformat_basic_format_trim = 1
local localprettier = {
  exe = './node_modules/.bin/prettier',
  args = {'--stdin', '--stdin-filepath', '"%:p"'},
  stdin = 1
}
vim.g.neoformat_javascript_localprettier = localprettier
vim.g.neoformat_enabled_javascript = {'localprettier', 'prettier'}
vim.g.neoformat_typescript_localprettier = localprettier
vim.g.neoformat_enabled_typescript = {'localprettier', 'prettier'}
vim.g.neoformat_typescriptreact_localprettier = localprettier
vim.g.neoformat_enabled_typescriptreact = {'localprettier', 'prettier'}
vim.g.neoformat_scss_localprettier = localprettier
vim.g.neoformat_enabled_scss = {'localprettier', 'prettier'}
vim.g.neoformat_elm_localelmformat = {
  exe = './node_modules/.bin/elm-format',
  args = {'--stdin', '--elm-version=0.19'},
  stdin = 1
}
vim.g.neoformat_enabled_elm = {'localelmformat', 'elmformat'}
util.autocmd(vimrc_group, 'BufWritePre', '*', 'NeoformatIfEnabled')

-- Linting
-- Find and run code linters on buffer write. Populates the location list with
-- errors and warning for the current buffer. ALE will automatically find and
-- use linters installed on your system, unless 'g:ale_linters' is set
-- otherwise. ALE can be set to lint as you type, but I find that distracting.
-- coa                shortcut for :ALEToggle
-- [l, [L, ]l, ]L     jump to previous, first, next, last location list entry
-- <Leader>l          toggle location list, where errors are populated
-- <Leader>i          call :ALEDetail
-- <Leader>k          call :ALEHover
-- <Leader>r          call :ALERename
-- <C-g><C-]>         call :ALEGoToDefinition
-- :ALELint           manually run linters
-- :ALEToggle         turn ALE on/off for current buffer
-- :ALEDetail         show expanded message for error on line
-- :ALEInfo           report available liners, settings, and linter log
-- :ALEHover          LSP hover, eg shows type signature in typescript
-- :ALEGoToDefinition LSP jump to symbol definition
-- :ALERename         LSP refactor symbol
packages.load('ale')
vim.g.ale_open_list = 0
vim.g.ale_list_window_size = 5
vim.g.ale_set_highlights = 1
vim.g.ale_set_signs = 0
vim.g.ale_lint_on_text_changed = 'never'
vim.g.ale_lint_on_insert_leave = 0
vim.g.ale_lint_on_enter = 1
vim.g.ale_lint_on_save = 1
vim.g.ale_fix_on_save = 1
vim.g.ale_linters = {
  elixir = {'credo', 'elixir-ls'}
}

-- Toggle location and quickfix lists
-- These lists may be used in a number of situations. Of note, ALE populates
-- the location list with linting errors, and selecting multiple fzf entries
-- with <TAB> adds the entries to the quickfix list.
-- <Leader>l        toggle location list
-- <Leader>q        toggle quickfix list
packages.load('ListToggle')

-- Completion
-- Manually activated completion suggestions. Deoplete uses many different
-- completion sources out of the box. Additionally add a source for completion
-- from ctags.
-- {Insert}<TAB>    open the popup menu with autocomplete suggestions
-- {PUM}<TAB>       scroll down through the popup menu
-- {PUM}<S-TAB>     scroll up through the popup menu
-- {PUM}<CR>        insert current popup menu selection
-- {PUM}<ESC>       cancel completion
packages.load('deoplete.nvim')
packages.load('neco-vim')
packages.load('neoinclude.vim')
packages.load('neco-syntax')
packages.load('deoplete-tag')
vim.g['deoplete#enable_at_startup'] = 1
vim.g['deoplete#disable_auto_complete'] = 1

-- Auto generate and manage ctags
-- Requires some version of ctags, such as Exuberant Ctags or Universal Ctags.
-- In order to generate tags Gutentags needs to know the root directory of the
-- current project. If you use version management then the project root should
-- be detected automatically. If you don't use version management then you'll
-- have to read the docs. If the project uses Git or Mercurial then tags will
-- only be generated for tracked files.
packages.load('vim-gutentags')
vim.g.gutentags_file_list_command = {
  markers = {['.git'] = 'git ls-files', ['.hg'] = 'hg files'}
}

-- Git integration
-- Commands all start with ':G*'.
-- gb               git blame in buffer
-- <Leader>gb       git blame in buffer
-- <Leader>gd       git diff on buffer
-- <Leader>gs       git status display
packages.load('vim-fugitive')

-- Browse Git history
-- Relies on fugitive.
-- :GV             view history for the current branch in a new tabpage
-- :GV!            view history for the current file in a new tabpage
-- :GV?            popuilate location list with file-specific commits
-- gt              go to next tabpage
-- gT              go to previous tabpage
packages.load('gv.vim')

-- Magit in vim
-- special buffer for staging and committing chunks of code.
-- :Magit           open magit buffer
-- :MagitOnly       open magit buffer in current buffer
-- gm               open magit buffer in current buffer
-- <Leader>gm       open magit buffer in current buffer
-- {Magit}?         view magit help
-- {Magit}q         close magit buffer
-- {Magit}R         refresh magit buffer
-- {Magit}S         stage/unstage selection or chunk
-- {Magit}L         stage/unstage line
-- {Magit}E         go to line in file for editing
-- {Magit}CC        commit staged changes
-- {Magit}CF        commit fixup to head and autosquash
-- {Magit}CA        amend last commit message
-- zo               open a fold
-- zc               close a fold
-- zi               toggle fold
packages.load('vimagit')

-- Simple file browser
-- View and navigate directories. The name of the Dirvish buffer is always set
-- to the current file path, so the % register can be used for file operations
-- such as `:!mkdir %foodir`, `:e %foo.txt`, or `:!rm %foo.txt`.
-- -                open Dirvish in file's directory
-- {Dirvish}-       move up to the parent directory
-- {Dirvish}q       return to buffer dirvish was called from
-- {Dirvish}<CR>    go to directory/edit file under cursor
-- {Dervish}L       show file info, like `ls -l`
packages.load('vim-dirvish')
vim.g.dirvish_mode = ':sort ,^.*[/],' -- show directories first

-- Multi-file search/replace
-- Perform a substitution across multiple files
-- :Search          open the prompt window to enter a search pattern
-- :Search pattern  search for a find/replace pattern to stage
-- :Replace newStr  Complete the replacement on staged search results
-- {SearchReplace}d delete a line/file from the staged results
packages.load('searchReplace.vim')

-- Smart commenting
-- gc{motion}       toggle commenting on lines that {motion} moves over
-- gcc              comment/uncomment line
packages.load('vim-commentary')

-- Make plugins like surround and unimpaired work with the '.' repeat command
packages.load('vim-repeat')

-- Manipulate surrounding pairs
-- cs{c1}{c1}            change surrounding chars from {c1} to {c2}
-- ds{c}                 delete surrounding chars {c}
-- ys{motion}{c}         add new surrounding chars {c}
-- {Visual}vs{c}         surround visual selection with {c}
-- <Leader>y{c}          surround word under cursor with {c}
-- <Leader>Y{c}          surround WORD under cursor with {c}
-- {Visual}<Leader>y{c}  surround visual selection with {c}
packages.load('vim-surround')

-- Change variable case/delineation
-- These bindings simplify the rare but tedious task of converting from one
-- style of variable naming to another. Two possible mnemonics are that cx is
-- 'change variable', or that <Leader>x is 'targeting' a word for change.
-- cx{*}            change case with a motion or selection
--   cxc            to camelCase
--   cxC            to CamelCase
--   cxs            to snake_case
--   cxS            to SNAKE_CASE
--   cxk            to kabab-case
--   cxK            to KABAB-CASE
--   cxd            to dot.case
--   cxd            to DOT.CASE
--   cxw            to word case
--   cxW            to WORD CASE
--   cxt            to Title Case
--   cxl            to lowercase
--   cxU            to UPPERCASE
-- <Leader>x{*}     change case for word under the cursor, as with cx{*}iw
-- <Leader>X{*}     change case for WORD under the cursor, as with cx{*}iW
packages.load('vim-caser')
vim.g.caser_prefix = 'cx'
vim.g.caser_custom_mappings = {
  CamelCase = {'c'},
  MixedCase = {'C'},
  SnakeCase = {'s'},
  UpperCase = {'S'},
  KebabCase = {'k'},
  KebabCapsCase = {'K'},
  DotCase = {'d'},
  DotCapsCase = {'D'},
  SpaceCase = {'w'},
  SpaceCapsCase = {'W'},
  TitleCase = {'t'},
  SentenceCase = {}
}

-- Repeat find and 'till easily
-- f or t           repeat last f/F/t/T motion forward
-- F or T           repeat last f/F/t/T motion backward
packages.load('clever-f.vim')
vim.g.clever_f_fix_key_direction = 1

-- Useful pairs of keybindings, toggle vim settings
-- [b, [B, ]b, ]B   previous, first, next, last buffer
-- [l, [L, ]l, ]L   previous, first, next, last location list entry
-- [q, [Q, ]q, ]Q   previous, first, next, last quickfix list entry
-- [t, [T, ]t, ]T   previous, first, next, last tag stack entry
-- [y{motion}       encode string with c-style escape sequences
-- ]y{motion}       decode string with c-style escape sequences
-- [-space          insert [count] blank line(s) above
-- ]-space          insert [count] blank line(s) below
-- gl               swap line with line below, custom binding for ]e
-- gL               swap line with line above, custom binding for [e
-- coh              toggle hlsearch
-- con              toggle line numbers
-- cor              toggle relative line numbers
-- cos              toggle spell check
-- cow              toggle wrap
packages.load('vim-unimpaired')

-- Unix file management integration
-- Includes ':Move', ':Rename', ':Delete', ':Mkdir'. Note that ':SudoEdit'
-- and ':SudoWrite' are broken in nvim.
packages.load('vim-eunuch')

-- Read/Write protected files
-- Alternative to ':SudoEdit' and ':SudoWrite'. Automatically runs when a new
-- protected file is opened.
-- :SudoEdit        open the current file with sudo
-- :SudoEdit foo    open the file foo with sudo
-- :SudoWrite       save the current file with sudo
-- :SudoWrite foo   write to foo with sudo
packages.load('suda.vim')
vim.g.suda_smart_edit = 1

-- Better in-buffer search defaults
-- Remove highlight after moving cursor, allow * search for selection.
-- {Visual}*        search for selection forward
-- {Visual}#        search for selection backward
packages.load('vim-slash')

-- Briefly highlight yanked text
packages.load('vim-highlightedyank')

-- View and navigate the undo tree
-- <Leader>u        toggle undo tree
-- {Undotree}?      show hotkeys and quick help
packages.load('undotree')
vim.g.undotree_SetFocusWhenToggle = 1

-- Navigate by variable segments/sections
-- Move and manipulate sections of camelCase or snake_case variables.
-- s                move forward one variable segment
-- S                move back one variable segment
-- is/as            text object for a variable segment
-- iS/aS            new mappings for sentence text object
packages.load('CamelCaseMotion')

-- Text object after a given character
-- Operate on text relative to characters specified in the
-- `after_object#enable` call.
-- a{c}             text object for part of line after next {c}
-- aa{c}            text object for part of line after previous {c}
packages.load('vim-after-object' )
util.autocmd(
  vimrc_group, "VimEnter", "*",
  "call after_object#enable('=', ':', '-', '_', ' ', '#', '?', '$', '!', '&')"
)

-- Additional text objects
-- il/al            text object for text in a line or the whole line
-- ie/ae            text object for entire buffer, whitespace excluded/included
-- ic/ac            text object for a comment's contents or the whole comment
-- Text object: l for a whole line or text in a line
packages.load('vim-textobj-user')
packages.load('vim-textobj-line')
packages.load('vim-textobj-entire')
packages.load('vim-textobj-comment')

-- TODO
packages.load('nvim-colorizer.lua')

-- ColorSchemes
-- Some nice colorschemes, most of which require true color.
packages.load('NeoSolarized')
packages.load('vim-two-firewatch')
packages.load('vim-colors-rakr')
packages.load('vim-colors-pencil')
packages.load('vim-colors-paramount')


--[[----------------------------------------------------------------------------
Theme & Statusline
Picking a theme requires knowing the color pallet limits of your terminal
emulator. Some terminals are limited to 16 or 256 colors, while 'true color'
terminals have the full hex color range. Counterintuitive, true color terminals
tend to set $TERM to 'xterm-256color', even though more than 256 colors are
available. Change the substring match on $TERM as needed to include/exclude
regularly used terminals.

I use something close to the default statusline, with the addition of
indicating the current git branch (requires fugitive) and showing linting
results (requires ALE).

Also set the tabline that is visible when more than one tabpage is open. The
default tabline tries to keep full file paths while abbreviating the path to
save space. The result is hard to read, just use the file name instead.
--]]----------------------------------------------------------------------------

local term = vim.env.TERM
local is_true_color_term =
  term == 'xterm-256color' or
  term == 'screen-256color' or
  term == 'xterm-kitty'

if is_true_color_term then
  opt.termguicolors = true
  opt.background = 'dark'
  vim.cmd('silent! colorscheme NeoSolarized')
  require('colorizer').setup()
else
  opt.termguicolors = false
  opt.background = 'light'
  vim.cmd('silent! colorscheme paramount')
end

-- Some colorschemes use the 'undercurle' squiggly line, which can be
-- distracting. This sets incorrect words and ALE errors to use an underline
-- instead.
util.autocmd(
  vimrc_group, 'ColorScheme', '*',
  'highlight clear SpellBad | highlight SpellBad cterm=underline gui=underline'
)

opt.statusline = table.concat({
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
})


--[[----------------------------------------------------------------------------
Key Mappings
Common editing commands and motions, listed in alphabetical order. I've added a
number of keymaps and changed a few defaults. Notable changes to default
behavior include:

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
{Insert}<Tab>    open completion menu, or scroll down through menu
{Insert}<S-Tab>  if the completion menu is open scroll up, else insert a tab
--]]----------------------------------------------------------------------------

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
--   coa            toggle ALE
--   cof            toggle Neoformat formatting on save
--   coh            toggle hlsearch
--   con            toggle line numbers
--   cor            toggle relative line numbers
--   cos            toggle spell check
--   cow            toggle wrap
--   co|            toggle colorcolumn at column 81
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
key.noremap {'C', '"_c'}
key.noremap {'CC', '"_cc'}
key.nnoremap {'coa', ':ALEToggle<CR>'}
key.nnoremap {'cof', require('helpers').neoformat_toggle}
key.nnoremap {'co|', require('helpers').toggle_color_column, silent = true}
key.noremap {'cxl', 'gu'}
key.noremap {'cxU', 'gU'}
-- ignore unimpaired's warnings about switching from co to yo
key.nmap {'co', 'yo'}

-- d{motion}        delete text
-- dd               delete line
-- ds{c}            delete surrounding chars {c}
-- D{motion}        delete text, do not save to register
-- DD               delete line, do not save to register
key.noremap {'D', '"_d'}
key.noremap {'DD', '"_dd'}

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
--   g!             arbitrary namespace saved for vim-caser bindings
--   g<C-]>         LSP goto definition
-- G                jump to end of file
-- <C-g>{*}         misc/variant CTRL actions
--   <C-g><C-]>     LSP goto definition, alias for g<C-]>
key.nnoremap {'gb', ':Gblame<CR>'}
key.nmap {'gl', 'v_]e'}
key.nmap {'gL', 'v_[e'}
key.nnoremap {'gm', ':MagitOnly<CR>'}
key.noremap {'gp', '"+p`]', silent = true}
key.noremap {'gP', '"+P'}
key.nnoremap {'gs', 'z='}
key.nmap {'gy', '"+y'}
key.vnoremap {'gy', '"+y`]', silent = true}
key.noremap {'gz', 'zz'}
key.nnoremap {'g<C-]>', ':ALEGoToDefinition<CR>'}
key.nnoremap {'<C-g><C-]>', ':ALEGoToDefinition<CR>'}

-- h                left
-- H                left 3 columns
-- <A-h>            previous buffer
-- {Term}<A-h>      previous buffer
-- <C-h>            focus window left
-- {Term}<C-h>      focus window left
key.nnoremap {'H', 'hhh'}
key.vnoremap {'H', 'hhh'}
key.nnoremap {'<A-h>', ':bprevious<CR>'}
key.tnoremap {'<A-h>', '<C-\\><C-n>:bprevious<CR>'}
key.nnoremap {'<C-h>', '<C-w>h'}
key.tnoremap {'<C-h>', '<C-\\><C-n><C-w>h'}

-- i                insert before cursor
-- I                insert at beginning of line
-- {VisualBlock}I   insert at beginning of each line in selection

-- j                down
-- J                down 3 lines
-- <C-j>            focus window below
-- {Term}<C-j>      focus window below
-- {Visual}<C-j>    move selection down one line
key.nnoremap {'J', 'jjj'}
key.vnoremap {'J', 'jjj'}
key.nnoremap {'<C-j>', '<C-w>j'}
key.tnoremap {'<C-j>', '<C-\\><C-n><C-w>j'}
key.vnoremap {'<C-j>', ':m "\'>+1<CR>gv=gv"'}

-- k                up
-- K                up 3 lines
-- <C-k>            focus window above
-- {Term}<C-k>      focus window above
-- {Insert}<C-k>    insert a diagraph (e.g. 'e' + ':' = 'ë')
-- {Visual}<C-k>    move selection up one line
key.nnoremap {'K', 'kkk'}
key.vnoremap {'K', 'kkk'}
key.nnoremap {'<C-k>', '<C-w>k'}
key.tnoremap {'<C-k>', '<C-\\><C-n><C-w>k'}
key.vnoremap {'<C-k>', ':m "\'<-2<CR>gv=gv"'}

-- l                right
-- L                right 3 columns
-- <A-l>            next buffer
-- {Term}<A-l>      next buffer
-- <C-l>            focus window right
-- {Insert}<C-l>    focus window right, leave insert mode
-- {Term}<C-l>      focus window right
key.nnoremap {'L', 'lll'}
key.vnoremap {'L', 'lll'}
key.nnoremap {'<A-l>', ':bnext<CR>'}
key.tnoremap {'<A-l>', '<C-\\><C-n>:bnext<CR>'}
key.nnoremap {'<C-l>', '<C-w>l'}
key.inoremap {'<C-l>', '<ESC><C-w>l'}
key.tnoremap {'<C-l>', '<C-\\><C-n><C-w>l'}

-- m{a-Z}           set mark char, where a-z marks in buffer, A-Z cross-buffers
-- M                jump middle, move cursor to middle line
-- mm               set mark M (jump with <Leader>m)
-- mn               set mark N (jump with <Leader>n)
key.noremap {'mm', 'mM'}
key.noremap {'mn', 'mN'}

-- n                jump to next search result
-- N                jump to previous search result

-- o                insert line below cursor
-- O                insert line above cursor
-- {Insert}<C-o>    execute one command then return to insert mode

-- p                put/paste after cursor, place cursor at end of pasted text
-- {Visual}p        put/paste over selection, place cursor at end of pasted text
-- P                paste before cursor
key.noremap {'p', 'p`]', silent = true}

-- q{c}             record macro to register {c}
-- @{c}             run macro from register {c}
-- Q                run @q macro
key.noremap {'Q', '@q'}

-- r                replace single character
-- R                enter replace mode

-- s                move forward by one camelCase or under_score word section
-- S                move backwards by one camelCase or under_score word section
-- {*}s and {*}S    surround actions
--   cs{c1}{c1}     change surrounding chars from {c1} to {c2}
--   ds{c}          delete surrounding chars {c}
--   ys{motion}{c}  add new surrounding chars {c}
--   {Visual}vs{c}  surround visual selection with {c}
key.map {'s', '<Plug>CamelCaseMotion_w', silent = true}
key.map {'S', '<Plug>CamelCaseMotion_b', silent = true}

-- t{c}             find 'til {c} forward
-- T{c}             find 'til {c} backwards
-- t                repeat last f/F/t/T motion forward
-- T                repeat last f/F/t/T motion backward

-- u                undo
-- {Visual}u        lowercase selection
-- U                redo
-- {Visual}U        uppercase selection
key.nnoremap {'U', '<C-r>'}

-- v                enter visual mode
-- {Visual}vs{c}    surround visual selection with {c}
-- V                enter visual line mode
-- <C-v>            enter blockwise visual mode
-- {Insert}<C-v>    insert a character literal (e.g. <TAB> instead of 2 spaces)
key.xmap {'vs', '<Plug>VSurround'}

-- w                move word forward
-- W                move WORD forward

-- x                delete char forward, don't save to register
-- X                delete char backward, don't save to register
-- <C-x>            decrement number under cursor (pairs with <C-a>)
key.noremap {'x', '"_x'}
key.noremap {'X', '"_X'}

-- y                yank/copy text
-- {Visual}y        yank selection, place cursor at end of selection
-- ys{motion}{c}    add new surrounding chars {c}
-- Y                join two lines (Y looks like two lines joining into one)
key.map {'y', '<Plug>(highlightedyank)'}
key.vnoremap {'y', 'y`]', silent = true}
key.noremap {'Y', 'J'}

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
--   [l, [L         previous, first location list entry
--   [q, [Q         previous, first quickfix list entry
--   [t, [T         previous, first tag stack entry
--   [s             previous misspelled word
--   [e             previous change list entry
--   [j             previous jump list location
-- ]{*}             forward list entry actions
--   ]b, ]B         next, last buffer
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
key.nnoremap {'[e', 'g;'}
key.nnoremap {']e', 'g,'}
key.nnoremap {'[j', '<C-o>'}
key.nnoremap {']j', '<C-i>'}
key.nnoremap {'<A-[>', '<C-o>'}
key.nnoremap {'<A-]>', '<C-i>'}
key.nnoremap {'<C-]>', 'g<C-]>'}

-- 0                go to first character of line
-- ^                go to start of line
-- $                go to end of line
key.nnoremap {'0', '^'}
key.nnoremap {'^', '0'}

-- %                jump to matching brace/bracket/paren

-- :                enter command mode
-- ;                enter command mode
key.nnoremap {';', ':'}
key.vnoremap {';', ':'}

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
key.vnoremap {'.', ':norm.<CR>'}

-- -                open Dirvish in file's directory
-- {Dirvish}-       move up to the parent directory
-- {Dirvish}q       return to buffer dirvish was called from
-- {Dirvish}<CR>    go to directory/edit file under cursor

-- <Tab>            indent line/selection
-- <S-Tab>          un-indent line/selection
-- {Insert}<Tab>    show completion menu, scroll down through menu
-- {Insert}<S-Tab>  if the completion menu is open scroll up, else insert a tab
key.nnoremap {'<Tab>', '>>'}
key.nnoremap {'<S-Tab>', '<<'}
key.vnoremap {'<Tab>', '>'}
key.vnoremap {'<S-Tab>', '<'}
key.inoremap {
  '<Tab>', 'pumvisible() ? "<C-n>" : deoplete#manual_complete()',
  silent = true, expr = true
}
key.inoremap {'<S-Tab>', 'pumvisible() ? "<C-p>" : "<Tab>"', expr = true}


--[[----------------------------------------------------------------------------
Leader Bindings
General convenience bindings -- search and navigation with fzf, git integration
with fugitive and magit, window management, useful odds and ends.
--]]----------------------------------------------------------------------------

-- Leader
vim.g.mapleader = ' '

-- <Leader>a  fzf search all text in project
-- <Leader>A  fzf search all text in project, full screen with preview
key.nnoremap {
  '<Leader>a',
  function()
    local term = vim.fn.input('Search project for: ')
    vim.fn.execute('Rg ' .. term)
  end,
  silent=true
}
key.nnoremap {
  '<Leader>A',
  function()
    local term = vim.fn.input('Search project for: ')
    vim.fn.execute('Rg! ' .. term)
  end,
  silent=true
}

-- <Leader>b  fzf search buffer list
key.nnoremap {'<Leader>b', ':Buffers<CR>', silent = true}

-- <Leader>c  close focused window
key.nnoremap {'<Leader>c', '<C-w><C-q>'}

-- <Leader>d  delete this buffer from buffer list, keep window if possible
key.nnoremap {'<Leader>d', ':bp<bar>sp<bar>bn<bar>bd<CR>'}

-- <Leader>e  fzf search everything on disk (like ':e /foo/bar')
key.nnoremap {'<Leader>e', ':Files /<CR>', silent = true}

-- <Leader>f  fzf search file paths, insert selected file path into buffer
key.nmap {'<Leader>f', 'i<Plug>(fzf-complete-file-ag)'}

-- <Leader>g{*}  git bindings
--   <Leader>gb  fugitive git blame
--   <Leader>gc  fzf search git commits
--   <Leader>gd  fugitive git diff
--   <Leader>gf  fzf search all files in current git repo
--   <Leader>gh  fzf search git commits for buffer (buffer's git history)
--   <Leader>gm  open magit in current buffer
--   <Leader>gs  fzf search `git status`, meaning files with unstaged changes
key.nnoremap {'<Leader>gb', ':Gblame<CR>', silent = true}
key.nnoremap {'<Leader>gc', ':Commits<CR>', silent = true}
key.nnoremap {'<Leader>gd', ':Gdiff<CR>', silent = true}
key.nnoremap {'<Leader>gf', ':GFiles<CR>', silent = true}
key.nnoremap {'<Leader>gh', ':BCommits<CR>', silent = true}
key.nnoremap {'<Leader>gm', ':MagitOnly<CR>', silent = true}
key.nnoremap {'<Leader>gs', ':GFiles?<CR>', silent = true}

-- <Leader>h  fzf search recently opened files history
-- <Leader>H  swap window left
key.nnoremap {'<Leader>h', ':History<CR>', silent = true}
key.nnoremap {'<Leader>H', '<C-w>H'}

-- <Leader>i  linting info related to error on line
-- <Leader>I  TODO
key.nnoremap {'<Leader>i', ':ALEDetail<CR>'}

-- <Leader>j  TODO
-- <Leader>J  swap window down
key.nnoremap {'<Leader>J', '<C-w>J'}

-- <Leader>k  show lsp hover info
-- <Leader>K  swap window up
key.nnoremap {'<Leader>k', ':ALEHover<CR>'}
key.nnoremap {'<Leader>K', '<C-w>K'}

-- <Leader>l  toggle location list, using ListToggle plugin
-- <Leader>L  swap window right
key.nnoremap {'<Leader>L', '<C-w>L'}

-- <Leader>m  jump to mark M
key.nnoremap {'<Leader>m', "'M"}

-- <Leader>n  jump to mark N
key.nnoremap {'<Leader>n', "'N"}

-- <Leader>o  TODO

-- <Leader>p  fzf search current project, meaning current git repo
key.nnoremap {'<Leader>p', ':GFiles<CR>', silent = true}

-- <Leader>q  toggle the quickfix list, using ListToggle plugin

-- <Leader>r  LSP rename symbol under cursor
-- <Leader>R  reference vim bindings, fzf search this vimrc
key.nnoremap {'<Leader>r', ':ALERename<CR>'}
key.nnoremap {'<Leader>R', ':RefConfig<CR>'}

-- <Leader>s  search and replace exact matches for word under cursor
-- <Leader>S  search and replace substring matches for word under cursor
key.nnoremap {'<Leader>s', ':%s/\\<<C-r><C-w>\\>/'}
key.nnoremap {'<Leader>S', ':%s/<C-r><C-w>/'}

-- <Leader>t{*}  test bindings
--   <Leader>tt  test this (run test under cursor)
--   <Leader>tf  test file
--   <Leader>ts  test suite
--   <Leader>tl  test last
--   <Leader>tg  test go (return to last ran test)
key.nnoremap {'<leader>tt', ':TestNearest<CR>', silent = true}
key.nnoremap {'<leader>tf', ':TestFile<CR>', silent = true}
key.nnoremap {'<leader>ts', ':TestSuite<CR>', silent = true}
key.nnoremap {'<leader>tl', ':TestLast<CR>', silent = true}
key.nnoremap {'<leader>tg', ':TestVisit<CR>', silent = true}

-- <Leader>u  toggle undotree
key.nnoremap {'<Leader>u', ':UndotreeToggle<CR>'}

-- <Leader>v  vertical split
-- <Leader>V  horizontal split
key.noremap {'<Leader>v', ':vsplit<CR>'}
key.noremap {'<Leader>V', ':split<CR>'}

-- <Leader>w  TODO

-- <Leader>x{*}          change case for word under the cursor
-- <Leader>X{*}          change case for WORD under the cursor
-- {Visual}<Leader>x{*}  change case for selection
key.nmap {'<Leader>xc', 'cxciw'}
key.nmap {'<Leader>xC', 'cxCiw'}
key.nmap {'<Leader>xs', 'cxsiw'}
key.nmap {'<Leader>xS', 'cxSiw'}
key.nmap {'<Leader>xk', 'cxkiw'}
key.nmap {'<Leader>xK', 'cxKiw'}
key.nmap {'<Leader>xd', 'cxdiw'}
key.nmap {'<Leader>xD', 'cxDiw'}
key.nmap {'<Leader>xw', 'cxwiw'}
key.nmap {'<Leader>xW', 'cxWiw'}
key.nmap {'<Leader>xt', 'cxtiw'}
key.nmap {'<Leader>xl', 'cxliw'}
key.nmap {'<Leader>xU', 'cxUiw'}
key.nmap {'<Leader>Xc', 'cxciW'}
key.nmap {'<Leader>XC', 'cxCiW'}
key.nmap {'<Leader>Xs', 'cxsiW'}
key.nmap {'<Leader>XS', 'cxSiW'}
key.nmap {'<Leader>Xk', 'cxkiW'}
key.nmap {'<Leader>XK', 'cxKiW'}
key.nmap {'<Leader>Xd', 'cxdiW'}
key.nmap {'<Leader>XD', 'cxDiW'}
key.nmap {'<Leader>Xw', 'cxwiW'}
key.nmap {'<Leader>XW', 'cxWiW'}
key.nmap {'<Leader>Xt', 'cxtiW'}
key.nmap {'<Leader>Xl', 'cxliW'}
key.nmap {'<Leader>XU', 'cxUiW'}
key.xmap {'<Leader>x', 'cx'}

-- <Leader>y{c}       surround a word with {c} ([y]ou surround word)
-- <Leader>Y{c}       surround a WORD with {c}
-- {Visual}<Leader>y  surround selection with {c}
key.nnoremap {'<Leader>y', ':execute "normal <Plug>Ysurround"<CR>g@iw'}
key.nnoremap {'<Leader>Y', ':execute "normal <Plug>Ysurround"<CR>g@iW'}
key.xmap {'<Leader>y', '<Plug>VSurround'}

-- <Leader>z  fzf search ctags (ctag[z])
-- <Leader>Z  fzf search helptags (helptag[Z])
key.nnoremap {'<Leader>z', ':Tags<CR>', silent = true}
key.nnoremap {'<Leader>Z', ':Helptags<CR>', silent = true}

-- <Leader>=  resize windows to split evenly
key.nnoremap {'<Leader>=', '<C-w>='}

-- <Leader>|  vertical split
-- <Leader>_  horizontal split
key.noremap {'<Leader>|', ':vsplit<CR>'}
key.noremap {'<Leader>_', ':split<CR>'}

-- <Leader>/  fzf search current buffer
-- <Leader>*  fzf search current buffer for text under cursor
key.nnoremap {'<Leader>/', ':BLines<CR>'}
key.nnoremap {'<Leader>*', ':BLines <C-r><C-w><CR>'}

-- <Leader><Leader>  switch between current and last buffer
key.nnoremap {'<Leader><Leader>', '<c-^>'}

-- <Leader><TAB>           fzf search normal mode mappings
-- {Visual}<Leader><TAB>   fzf search visual mode mappings
-- {Pending}<Leader><TAB>  fzf search operator-pending mode mappings
key.nmap {'<leader><tab>', '<plug>(fzf-maps-n)'}
key.xmap {'<leader><tab>', '<plug>(fzf-maps-x)'}
key.omap {'<leader><tab>', '<plug>(fzf-maps-o)'}

-- {Term}<Leader><ESC>  switch from terminal mode to reading terminal as buffer
key.tnoremap {'<Leader><ESC>', '<C-\\><C-n>'}


--[[----------------------------------------------------------------------------
Filetype/Env Settings
Mappings and options for specific file types and environments.
--]]----------------------------------------------------------------------------

-- Use the local leader for filetype specific mappings
vim.g.maplocalleader = "\\"

-- text: wrap at 80 characters
util.autocmd(vimrc_group, 'FileType', 'text', 'setlocal textwidth=80')
util.autocmd(vimrc_group, 'FileType', 'markdown', 'setlocal textwidth=80')

-- vim: reload vimrc every time this buffer is saved
util.autocmd(vimrc_group, 'BufWritePost', 'init.lua', 'luafile $MYVIMRC')

-- elm: use 4 spaces to indent
util.autocmd(vimrc_group, 'FileType', 'elm', 'setlocal tabstop=4')
util.autocmd(vimrc_group, 'FileType', 'elm', 'setlocal shiftwidth=4')

-- python: tab nonsense
util.autocmd(vimrc_group, 'FileType', 'python', 'setlocal noexpandtab')
util.autocmd(vimrc_group, 'FileType', 'python', 'setlocal tabstop=8')
util.autocmd(vimrc_group, 'FileType', 'python', 'setlocal softtabstop=8')

-- git: wrap at 72 characters
util.autocmd(vimrc_group, 'FileType', 'gitcommit', 'setlocal textwidth=72')
util.autocmd(vimrc_group, 'FileType', 'magit', 'setlocal textwidth=72')

-- js and ts might use incomplete import paths
util.autocmd(vimrc_group, 'FileType', 'javascript', 'setlocal path+=src/**,assets/**')
util.autocmd(vimrc_group, 'FileType', 'typescript', 'setlocal path+=src/**,assets/**')
util.autocmd(vimrc_group, 'FileType', 'typescript.tsx', 'setlocal path+=src/**,assets/**')
util.autocmd(vimrc_group, 'FileType', 'typescriptreact', 'setlocal path+=src/**,assets/**')

-- dirvish: Use <leader>k for file info instead of K, K jumps 3 lines
util.autocmd(vimrc_group, 'FileType', 'dirvish', 'map <silent><buffer> <leader>k <Plug>(dirvish_K)')
util.autocmd(vimrc_group, 'FileType', 'dirvish', 'noremap <silent><buffer> K kkk')

-- vim help: K for zoomies not info
util.autocmd(vimrc_group, 'FileType', 'help', 'noremap <silent><buffer> K kkk')


--[[----------------------------------------------------------------------------
Text Objects
Note that the 's' sentence text object have been re-mapped to 'S', and the
original bindings have been repurposed for variable segments/sections.
--]]----------------------------------------------------------------------------

-- i{*}             inner/inside text object
-- a{*}             a/all of text object, includes surrounding whitespace
--   c              comment
--   e              entire buffer
--   l              line
--   p              paragraph
--   s              variable segment, either snake_case or camelCase
--   S              sentence
--   t              html tags
--   w              word
--   W              WORD
--   [ or ], ( or ),
--   < or >, { or } matching pairs
--   `, ", '        matching quotes
key.onoremap {'iS', 'is', silent = true}
key.xnoremap {'iS', 'is', silent = true}
key.onoremap {'aS', 'as', silent = true}
key.xnoremap {'aS', 'as', silent = true}
key.omap {'is', '<Plug>CamelCaseMotion_iw', silent = true}
key.xmap {'is', '<Plug>CamelCaseMotion_iw', silent = true}
key.omap {'as', '<Plug>CamelCaseMotion_iw', silent = true}
key.xmap {'as', '<Plug>CamelCaseMotion_iw', silent = true}


--[[----------------------------------------------------------------------------
Commands
--]]----------------------------------------------------------------------------

-- Highlight the color column, defaults to col 81 if nothing else is set
util.def_cmd {'TCC', require("helpers").toggle_color_column}

-- Toggle Neoformat so that it doesn't run on every save
util.def_cmd {'NeoformatToggle', require("helpers").neoformat_toggle}

-- Run Neoformat as long as NeoformatToggle has not disabled it
util.def_cmd {'NeoformatIfEnabled', require("helpers").neoformat_if_enabled}

-- Use suda to replace ':SudoEdit' and ':SudoWrite'
util.def_cmd {'SudoEdit',  'SudaRead <args>', nargs = '?'}
util.def_cmd {'SudoWrite', 'SudaWrite <args>', nargs = '?'}

-- util.command {
--   'RefConfig',
--   [[
--     call fzf#vim#buffer_lines(<q-args>,
--       fzf#vim#with_preview({
--         'source': 'bat --style="${BAT_STYLE:-numbers}" --color=always --pager=never "$MYVIMRC"',
--         'placeholder': fzf#shellescape(expand($MYVIMRC)) . ':{1}',
--         'options': ['--prompt', 'Config> ', '--preview-window', '+{1}-/2']
--       }),
--     <bang>0)
--   ]],
--   nargs = "*", bang = true
-- }

-- Paq starts with ':Paq*', includes Install, Clean, Update, Upgrade.

-- Git starts with ':G*', includes blame, diff. Use ':GV' to view git history.

-- Unix utilities include ':Move', ':Rename', ':Delete', ':Mkdir'. Note that
-- ':SudoEdit' and ':SudoWrite' are broken in nvim.

-- Rails
-- ':Rpreview' open webpage, ':A' edit 'alternate' file (usually test)
-- ':R' edit 'related' file (depends), editing specific files starts with ':E*'

-- Linting starts with ':ALE*', includes Lint, Toggle, Detail, Info.

-- Search/Replace
-- ':Search' opens the prompt window to enter a search pattern, and ':Replace
-- newStr' replaces all instances of the pattern with the new value.

-- FZF
-- ':Files [PATH]'      Files
-- ':GFiles [OPTS]'     Git files
-- ':GFiles?'           Git files
-- ':Buffers'           Open buffers
-- ':Colors'            Color schemes
-- ':Ag [PATTERN]'      ag search result
-- ':Rg [PATTERN]'      rg search result
-- ':Lines [QUERY]'     Lines in loaded buffers
-- ':BLines [QUERY]'    Lines in the current buffer
-- ':Tags [QUERY]'      Tags in the project
-- ':BTags [QUERY]'     Tags in the current buffer
-- ':Marks'             Marks
-- ':Windows'           Windows
-- ':Locate PATTERN'    `locate` command output
-- ':History'           `v:oldfiles` and open buffers
-- ':History:'          Command history
-- ':History/'          Search history
-- ':Commits'           Git commits
-- ':BCommits'          Git commits for the current buffer
-- ':Commands'          Commands
-- ':Maps'              Normal mode mappings
-- ':Helptags'          Help tags
-- ':Filetypes'         File types


--[[----------------------------------------------------------------------------
All the Little Things
--]]----------------------------------------------------------------------------

opts {
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
  wildmode = "longest:full",        -- bash-style command mode completion
  fillchars = "vert:▐",             -- use vertical bars to divide windows
  completeopt = "menuone,preview",  -- show completion menu for a single option
  matchpairs = "(:),{:},[:],<:>"    -- highlight matching angle brackets
}


--[[----------------------------------------------------------------------------
Metadata Files
In general neovim stores metadata files in '$XDG_DATA_HOME/nvim/*', which
most likely resolves to '~/.local/share/nvim/*'.
--]]----------------------------------------------------------------------------

-- don't save file backups, but if backups are saved, don't co-locate them with
-- the original file, use '~/.local/share/nvim/backup/' instead
opt.backup = false
opt.backupdir = vim.fn.stdpath('data')..'/backup/'
-- unlike with swap, undo, and shada, nvim won't auto-mkdir for backups
if not vim.fn.isdirectory(vim.fn.expand(opt.backupdir)) then
  vim.fn.mkdir(vim.fn.expand(opt.backupdir), "p")
end

-- save swap files to '~/.local/share/nvim/swap//'
opt.swapfile = true

-- save undo history files to '~/.local/share/nvim/undo//'
opt.undofile = true

-- Use the default setting for the shada (shared data) file. See ':h 'shada''
-- for details. Saves to '~/.local/share/nvim/shada/main.shada'.