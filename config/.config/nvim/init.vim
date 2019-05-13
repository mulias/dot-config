"===============================================================================
" init.vim
" My cleaned up and documented config for neovim.
"
" Vim Compatibility
" This config is only intended to work for neovim. If I only have access to
" standard vim then I use a minimal config with the addition of the plugin
" 'tpope/vim-sensible'.
"
" Setup
" * Run ':DownloadPlug' to download the vim-plug package manager. Restart.
" * Run ':PlugInstall' to fetch and install plugins.
" * Run ':CheckHealth' and make sure all checks are green. Install any missing
"   libraries needed for Ruby, Python2, and Python3 support.
" * FZF: Install Ag.
" * Neoformat: Install formatters for regularly used languages.
" * ALE: Install linters for regularly used languages. Use ':ALEInfo' on a file
"   to find out about linting that file type.
" * Gutentags: Install Universal Ctags, or disable gutentags.
"
" Documentation
" The goal is to over-document, so that this file can act not only as a
" configuration, but as a reference for learning/relearning vim features. I
" try to use a notation that is consistent with or at least inspired by the
" notation used in the vim docs, which is specified in ':help notation'.
" Special notation includes:
" * I use {c} to mean a single required character, and {*} to mean a single
"   character, restricted to the list immediately following.
" * When a key combination is specific to a mode or environment I preface it
"   with {EnvName}. The docs use {Visual}, but I've added {Insert}, {FZF},
"   {Magit}, etc.
"
"===============================================================================

" Base Directories, see ':h base-directories'
let g:nvim_config_dir = stdpath("config")
let g:nvim_data_dir = stdpath("data")

" Allow multibyte characters in this config. I don't think this is necessary
" in neovim, but it makes the vim linter 'vint' happy.
scriptencoding utf-8

" Make an autocmd group to use in this file. All autocmds should be bound to a
" group to prevents repeated autocmd execution when this config is sourced.
augroup vimrc
  autocmd!
augroup END


"===============================================================================
" Plugins
" Use vim-plug to manage plugins (https://github.com/junegunn/vim-plug)
" Manage with ':PlugInstall', ':PlugUpdate', ':PlugClean', and ':PlugUpgrade'.
"===============================================================================

call plug#begin(g:nvim_config_dir . '/plugged')

" Search and navigate with fuzzy find
" Open fzf in a terminal buffer, with values loaded in from different sources.
" Installs fzf locally to vim, instead or globally on the system.
" <Leader>a        fzf search with ag (search all text in project)
" <Leader>A        fzf search with ag, full screen with preview
" <Leader>b        fzf search buffer list
" <Leader>e        fzf search all files under home dir
" <Leader>gc       fzf search git commits
" <Leader>gf       fzf search all files in current git repo (alias '<leader>p')
" <Leader>gh       fzf search git commits for buffer (buffer's git history)
" <Leader>gs       fzf search `git status`, meaning files with unstaged changes
" <Leader>h        fzf search recently opened files history
" <Leader>p        fzf search current project, meaning current git repo
" <Leader>z        fzf search ctags (ctag[z])
" <Leader>Z        fzf search helptags (helptag[Z])
" <Leader>/        fzf search current buffer
" <Leader>*        fzf search current buffer for text under cursor
" {FZF}<TAB>       select multiple results to open
" {FZF}<C-t>       open in new tab
" {FZF}<C-s>       open in horizontal split
" {FZF}<C-v>       open in vertical split
Plug 'junegunn/fzf', { 'dir': g:nvim_config_dir . '/fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \ }

" Formatting
" Find and run code formatters on buffer write. Neoformat automatically
" searches for global executables, but not project-local ones. I've
" added a prettier config for JS and TS that checks node_modules first,
" then falls back on a global prettier install.
" cof                                enable/disable formatting on save
" :Neoformat [formatter]             run formatting on the current buffer
" {Visual}:Neoformat [formatter]     run formatting on selection
Plug 'sbdchd/neoformat'
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1
let g:neoformat_javascript_localprettier = {
  \ 'exe': './node_modules/.bin/prettier',
  \ 'args': ['--stdin', '--stdin-filepath', '"%:p"'],
  \ 'stdin': 1
  \ }
let g:neoformat_enabled_javascript = ['localprettier', 'prettier']
let g:neoformat_typescript_localprettier = {
  \ 'exe': './node_modules/.bin/prettier',
  \ 'args': ['--stdin', '--stdin-filepath', '"%:p"', '--parser', 'typescript'],
  \ 'stdin': 1
  \ }
let g:neoformat_enabled_typescript = ['localprettier', 'prettier']
autocmd vimrc BufWritePre * NeoformatIfEnabled

" Linting
" Find and run code linters on buffer write. Populates the location list with
" errors and warning for the current buffer. ALE will automatically find and
" use linters installed on your system, unless 'g:ale_linters' is set
" otherwise. ALE can be set to lint as you type, but I find that distracting.
" coa              shortcut for :ALEToggle
" [l, [L, ]l, ]L   jump to previous, first, next, last location list entry
" <Leader>i        linting info related to error on line
" <Leader>l        toggle location list
" :ALELint         manually run linters
" :ALEToggle       turn ALE on/off for current buffer
" :ALEDetail       show expanded message for error on line
" :ALEInfo         report available liners, settings, and linter log
Plug 'w0rp/ale'
let g:ale_linters = {
  \ 'typescript': ['eslint', 'tslint']
  \}
let g:ale_fixers = {
  \ 'typescript': ['eslint', 'tslint']
  \}
let g:ale_open_list = 0
let g:ale_list_window_size = 5
let g:ale_set_highlights = 1
let g:ale_set_signs = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1

" Toggle location and quickfix lists
" These lists may be used in a number of situations. Of note, ALE populates
" the location list with linting errors, and selecting multiple fzf entries
" with <TAB> adds the entries to the quickfix list.
" <Leader>l        toggle location list
" <Leader>q        toggle quickfix list
Plug 'Valloric/ListToggle'

" Completion (NCM)
" Provides a dropdown menu with completion suggestions. Completion sources are
" configured with NCM specific plugins. NCM can be set to make suggestions as
" you type, but I prefer to call NCM manually with <TAB>.
" {Insert}<Tab>    open popup menu with completion suggestions
" {Insert}<S-Tab>  insert the tab character
" {Pmenu}<Tab>     scroll down through completion suggestions
" {Pmenu}<S-Tab>   scroll up through completion suggestions
" Plug 'ncm2/ncm2', { 'do': ':UpdateRemotePlugins' }
" Plug 'roxma/nvim-yarp'           " ncm2 dependency
" Plug 'ncm2/ncm2-bufword'         " open buffer contents
" Plug 'ncm2/ncm2-gtags'           " ctags/gtags managed by gutentags
" Plug 'ncm2/ncm2-path'            " file paths
" Plug 'ncm2/ncm2-tmux'            " tmux contents
" Plug 'ncm2/ncm2-syntax'          " language keywords from vim syntax files
" Plug 'Shougo/neco-syntax'        " ncm2-syntax dependency
" Plug 'ncm2/ncm2-cssomni'         " css, scss, sass, etc.
" let g:ncm2#auto_popup = 0
" let g:ncm2#complete_length=[[1,1]]
" autocmd vimrc BufEnter * call ncm2#enable_for_buffer()
" imap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Plug>(ncm2_manual_trigger)"

" Completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1
let g:deoplete#disable_auto_complete = 1

" Auto generate and manage ctags
" Requires some version of ctags, such as Exuberant Ctags or Universal Ctags.
" In order to generate tags Gutentags needs to know the root directory of the
" current project. If you use version management then the project root should
" be detected automatically. If you don't use version management then you'll
" have to read the docs. If the project uses Git or Mercurial then tags will
" only be generated for tracked files.
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_file_list_command = {
  \ 'markers': {'.git': 'git ls-files', '.hg': 'hg files'}
  \ }

" Git integration
" Commands all start with ':G*'.
" gb               git blame in buffer
" <Leader>gb       git blame in buffer
" <Leader>gd       git diff on buffer
" <Leader>gs       git status display
Plug 'tpope/vim-fugitive'

" Browse Git history
" Relies on fugitive.
" :GV             view history for the current branch in a new tabpage
" :GV!            view history for the current file in a new tabpage
" :GV?            popuilate location list with file-specific commits
" gt              go to next tabpage
" gT              go to previous tabpage
Plug 'junegunn/gv.vim'

" Magit in vim
" special buffer for staging and committing chunks of code.
" :Magit           open magit buffer
" :MagitOnly       open magit buffer in current buffer
" gm               open magit buffer in current buffer
" <Leader>gm       open magit buffer in current buffer
" {Magit}?         view magit help
" {Magit}q         close magit buffer
" {Magit}R         refresh magit buffer
" {Magit}S         stage/unstage selection or chunk
" {Magit}L         stage/unstage line
" {Magit}CC        commit staged changes
" {Magit}CF        commit fixup to head and autosquash
" zo               open a fold
" zc               close a fold
" zi               toggle fold
Plug 'jreybert/vimagit'

" Simple file browser
" View and navigate directories. The name of the Dirvish buffer is always set
" to the current file path, so the % register can be used for file operations
" such as `:!mkdir %foodir`, `:e %foo.txt`, or `:!rm %foo.txt`.
" -                open Dirvish in file's directory
" {Dirvish}-       move up to the parent directory
" {Dirvish}q       return to buffer dirvish was called from
" {Dirvish}<CR>    go to directory/edit file under cursor
Plug 'justinmk/vim-dirvish'
let g:dirvish_mode = ':sort ,^.*[\/],' " show directories first

" Smart commenting
" gc{motion}       toggle commenting on lines that {motion} moves over
" gcc              comment/uncomment line
Plug 'tpope/vim-commentary'

" Manipulate surrounding pairs
" cs{c1}{c1}       change surrounding chars from {c1} to {c2}
" ds{c}            delete surrounding chars {c}
" ys{motion}{c}    add new surrounding chars {c}
" {Visual}S{c}     surround selection with {c}
" <Leader>y{c}     shortcut for ysiw{c}, surround word under cursor with {c}
" <Leader>Y{c}     shortcut for ysiW{c}, surround WORD under cursor with {c}
Plug 'tpope/vim-surround'

" Repeat find and 'till easily
" f or t           repeat last f/F/t/T motion forward
" F or T           repeat last f/F/t/T motion backward
Plug 'rhysd/clever-f.vim'
let g:clever_f_fix_key_direction = 1

" Change and repeat
" New edit action which replaces text like c{motion}, but can be repeated to
" find and replaces the next instance of the replaced text.
" c.{motion}       change text, find and repeat with .
" c>{motion}       change text backwards, find and repeat with .
Plug 'hauleth/sad.vim'

" Useful pairs of keybindings, toggle vim settings
" [b, [B, ]b, ]B   previous, first, next, last buffer
" [l, [L, ]l, ]L   previous, first, next, last location list entry
" [q, [Q, ]q, ]Q   previous, first, next, last quickfix list entry
" [t, [T, ]t, ]T   previous, first, next, last tag stack entry
" [y{motion}       encode string with c-style escape sequences
" ]y{motion}       decode string with c-style escape sequences
" [-space          insert [count] blank line(s) above
" ]-space          insert [count] blank line(s) below
" gl               swap line with line below, custom binding for ]e
" gL               swap line with line above, custom binding for [e
" coh              toggle hlsearch
" con              toggle line numbers
" cor              toggle relative line numbers
" cos              toggle spell check
" cow              toggle wrap
Plug 'tpope/vim-unimpaired'

" Make surround and unimpaired work with the "." repeat command
Plug 'tpope/vim-repeat'

" Unix file management integration
" Includes ':Move', ':Rename', ':Delete', ':Mkdir'. Note that ':SudoEdit' and
" ':SudoWrite' are broken in nvim.
Plug 'tpope/vim-eunuch'

" Better in-buffer search defaults
" Remove highlight after moving cursor, allow * search for selection.
" {Visual}*        search for selection forward
" {Visual}#        search for selection backward
Plug 'junegunn/vim-slash'

" Briefly highlight yanked text
Plug 'machakann/vim-highlightedyank'

" View and navigate the undo tree
" <Leader>u        toggle undo tree
" {Undotree}?      show hotkeys and quick help
Plug 'mbbill/undotree'
let g:undotree_SetFocusWhenToggle = 1

" Navigate by variable segments/sections
" Move and manipulate sections of camelCase or snake_case variables.
" s                move forward one variable segment
" S                move back one variable segment
" is/as            text object for a variable segment
" iS/aS            new mappings for sentence text object
Plug 'bkad/CamelCaseMotion'

" Additional text objects
" l                text object for a whole line or text in a line
" e                text object for entire buffer, with/without trailing new lines
" c                text object for a whole comment or the comment's contents
Plug 'kana/vim-textobj-user' " dependency for textobj plugins
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-entire'
Plug 'glts/vim-textobj-comment'

" Syntax/indent/compiler support
" Provides general functionality for many popular file types. Best used for
" languages that are rarely needed, or require no special functionality.
" Commonly used languages should be required separately and explicitly
" disabled for polyglot.
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = [
  \ 'elm',
  \ 'ruby',
  \ 'javascript',
  \ 'clojure',
  \ 'elixir'
  \ ]

" Elm
" Integrate with elm tooling. These features require that the vim root
" directory is also the base directory of the elm project. If vim is opened
" from the elm project's 'src/' then elm-make and elm-oracle will fail.
" :ElmMake         compile the current file
" :ElmMakeMain     compile 'Main.elm'
" :ElmTest         run all tests, for specific files use vim-test
" :ElmFormat       run elm-format manually, instead of waiting for neoformat
" :ElmShowDocs      doc results from elm-oracle for word under cursor
" <LocalLeader>m   compile current file
" <LocalLeader>M   compile 'Main.elm'
" <LocalLeader>t   run all tests
" <LocalLeader>f   formal buffer
" <LocalLeader>d   shows the docs for the word under the cursor
" <LocalLeader>D   opens web browser to docs for the word under the cursor
Plug 'elmcast/elm-vim'
let g:elm_setup_keybindings = 0

" Ruby
Plug 'vim-ruby/vim-ruby'

" Rails
" Many different helper tools for rials apps. I only really use the navigation
" shortcuts.
" gf               go to rails file under cursor
" :Rpreview        open webpage for file
" :A               edit 'alternate' file (usually test)
" :R               edit 'related' file (depends)
" :E*              starts many commands for editing different types of files
Plug 'tpope/vim-rails'

" Javascript
Plug 'pangloss/vim-javascript'
Plug 'hotoo/jsgf.vim'
let g:javascript_plugin_flow = 1
let g:javascript_plugin_jsdoc = 1

" Typescript
Plug 'herringtondarkholme/yats.vim'

" Clojure
Plug 'tpope/vim-fireplace'
Plug 'venantius/vim-cljfmt'

" Elixir
Plug 'elixir-editors/vim-elixir'

" ColorSchemes
" Some nice colorschemes, most of which require true color.
Plug 'iCyMind/NeoSolarized'
Plug 'chriskempson/base16-vim'
Plug 'rakr/vim-two-firewatch'
Plug 'rakr/vim-colors-rakr'
Plug 'reedes/vim-colors-pencil'
Plug 'morhetz/gruvbox'

call plug#end()


"===============================================================================
" Theme & Statusline
" Picking a theme requires knowing the color pallet limits of your terminal
" emulator. Some terminals are limited to 16 or 256 colors, while 'true color'
" terminals have the full hex color range. Counterintuitive, true color
" terminals tend to set $TERM to 'xterm-256color', even though more than 256
" colors are available. Change the substring match on $TERM as needed to
" include/exclude regularly used terminals.
"
" I use something close to the default statusline, with the addition of
" indicating the current git branch (requires fugitive) and showing linting
" results (requires ALE).
"
" Also set the tabline that is visible when more than one tabpage is open. The
" default tabline tries to keep full file paths while abbreviating the path to
" save space. The result is hard to read, just use the file name instead.
"===============================================================================

if $TERM =~# 'xterm-256color' ||
 \ $TERM =~# 'screen-256color'      " true color terminals
  set termguicolors
  set background=dark
  colorscheme NeoSolarized
else                                " limited pallet terminals
  set background=light
  colorscheme my_theme_light
endif

set statusline=%f                         " full filepath
set statusline+=%1(%)                     " padding
set statusline+=%h%q%w                    " tags: help, quickfix, preview
set statusline+=%m%r                      " tags: modified, read only
set statusline+=%([%{fugitive#head()}]%)  " git branch
set statusline+=%<                        " truncate point
set statusline+=%3(%)                     " padding
set statusline+=%{StatuslineALE()}        " ALE errors/warnings, if any exist
set statusline+=%=                        " right align
set statusline+=%12(%l,%c%)%5p%%          " line and col number, % through file

set tabline=%!MyTabLine()  " Build the tabline by iterating through the tab list


"===============================================================================
" Key Mappings
" Common editing commands and motions, listed in alphabetical order. I've
" added a number of keymaps and changed a few defaults. Notable changes to
" default behavior include:
"
" C{motion}        change text, do not save to register
" D{motion}        delete text, do not save to register
" H                left 3 columns
" J                down 3 lines
" K                up 3 lines
" L                right 3 columns
" Q                @q, execute the macro in register q
" U                redo
" x                delete char forward, don't save to register
" X                delete char backward, don't save to register
" Y                join two lines (Y looks like two lines joining into one)
" ;                enter command mode
" 0                go to first character of line
" ^                go to start of line
" {Insert}<Tab>    open completion menu, or scroll down through menu
" {Insert}<S-Tab>  if the completion menu is open scroll up, else insert a tab
"===============================================================================

" a                insert after cursor
" A                insert at end of line
" <C-a>            increment number under cursor (pairs with <C-x>)

" b                move word backward
" B                move WORD backward

" c{motion}        change text
" cc               change line
" C{motion}        change text, do not save to register
" CC               change line, do not save to register
" co{*}            toggle options
"   coa            toggle ALE
"   cof            toggle Neoformat formatting on save
"   coh            toggle hlsearch
"   con            toggle line numbers
"   cor            toggle relative line numbers
"   cos            toggle spell check
"   cow            toggle wrap
"   co|            toggle colorcolumn at column 81
"   co-            toggle cursor line highlight
" c.{motion}       change text, find and repeat with .
" c>{motion}       change text backwards, find and repeat with .
noremap C "_c
noremap CC "_cc
nnoremap coa :ALEToggle<CR>
nnoremap cof :NeoformatToggle<CR>
nnoremap <silent> co<bar> :TCC<CR>
nmap c. <Plug>(sad-change-forward)
nmap c> <Plug>(sad-change-backward)
xmap c. <Plug>(sad-change-forward)
xmap c> <Plug>(sad-change-backward)

" d{motion}        delete text
" dd               delete line
" D{motion}        delete text, do not save to register
" DD               delete line, do not save to register
noremap D "_d
noremap DD "_dd

" e                move to end of word
" E                move to end of WORD

" f{c}             find {c} forward
" F{c}             finds {c} backwards
" f                repeat last f/F/t/T motion forward
" F                repeat last f/F/t/T motion backward

" g{*}             misc/variant actions
"   gc{motion}     toggle commenting on lines that {motion} moves over
"   gcc            comment/uncomment line
"   gf             edit file at filepath under cursor
"   gg             jump to start of file, or line N for {N}gg
"   gj             down through a wrapped text line
"   gk             up through a wrapped text line
"   gl             swap current line with line [count] below
"   gL             swap current line with line [count] above
"   gm             switch to magit in current buffer
"   gp             paste from system clipboard, move cursor to end of pasted
"   {Visual}gp     paste from system clipboard over selection, move to end
"   gP             paste from system clipboard, put text before cursor
"   gq             reformat/wrap text
"   gs             give spelling suggestions
"   gt             go to the next tabpage
"   gT             go to the previous tabpage
"   gu{motion}     lowercase
"   gU{motion}     uppercase
"   guu            lowercase line
"   gUU            uppercase line
"   gv             re-select last visual selection
"   gy             yank to system clipboard
"   {Visual}gy     yank selection to system clipboard
"   gz             center window on cursor line
"   g?             rot13 selection/motion
" G                jump to end of file
nnoremap gb :Gblame<CR>
nmap gl v_]e
nmap gL v_[e
nnoremap gm :MagitOnly<CR>
noremap <silent> gp "+p`]
noremap gP "+P
nnoremap gs z=
nmap gy "+y
vnoremap <silent> gy "+y`]
noremap gz zz

" h                left
" H                left 3 columns
" <A-h>            previous buffer
" {Term}<A-h>      previous buffer
" <C-h>            focus window left
" {Term}<C-h>      focus window left
nnoremap H hhh
nnoremap <A-h> :bprevious<CR>
tnoremap <A-h> <C-\><C-n>:bprevious<CR>
nnoremap <C-h> <C-w>h
tnoremap <C-h> <C-\><C-n><C-w>h

" i                insert before cursor
" I                insert at beginning of line
" {VisualBlock}I   insert at beginning of each line in selection

" j                down
" J                down 3 lines
" <C-j>            focus window below
" {Term}<C-j>      focus window below
nnoremap J jjj
vnoremap J jjj
nnoremap <C-j> <C-w>j
tnoremap <C-j> <C-\><C-n><C-w>j

" k                up
" K                up 3 lines
" <C-k>            focus window above
" {Term}<C-k>      focus window above
" {Insert}<C-k>    insert a diagraph (e.g. 'e' + ':' = 'ë')
nnoremap K kkk
vnoremap K kkk
nnoremap <C-k> <C-w>k
tnoremap <C-k> <C-\><C-n><C-w>k

" l                right
" L                right 3 columns
" <A-l>            next buffer
" {Term}<A-l>      next buffer
" <C-l>            focus window right
" {Insert}<C-l>    focus window right, leave insert mode
" {Term}<C-l>      focus window right
nnoremap L lll
nnoremap <A-l> :bnext<CR>
tnoremap <A-l> <C-\><C-n>:bnext<CR>
nnoremap <C-l> <C-w>l
inoremap <C-l> <ESC><C-w>l
tnoremap <C-l> <C-\><C-n><C-w>l

" m{a-Z}           set mark char, where a-z marks in buffer, A-Z cross-buffers
" M                jump middle, move cursor to middle line
" mm               set mark M (jump with <Leader>m)
" mn               set mark N (jump with <Leader>n)
noremap mm mM
noremap mn mN

" n                jump to next search result
" N                jump to previous search result

" o                insert line below cursor
" O                insert line above cursor
" {Insert}<C-o>    execute one command then return to insert mode

" p                put/paste after cursor, place cursor at end of pasted text
" {Visual}p        put/paste over selection, place cursor at end of pasted text
" P                paste before cursor
noremap <silent> p p`]

" q{c}             record macro to register {c}
" @{c}             run macro from register {c}
" Q                run @q macro
noremap Q @q

" r                replace single character
" R                enter replace mode

" s                move forward by one camelCase or under_score word section
" S                move backwards by one camelCase or under_score word section
" s and S          surround actions
"   cs{c1}{c1}     change surrounding chars from {c1} to {c2}
"   ds{c}          delete surrounding chars {c}
"   ys{motion}{c}  add new surrounding chars {c}
"   {Visual}S{c}   surround selection with {c}
map <silent> s <Plug>CamelCaseMotion_w
map <silent> S <Plug>CamelCaseMotion_b

" t{c}             find 'til {c} forward
" T{c}             find 'til {c} backwards
" t                repeat last f/F/t/T motion forward
" T                repeat last f/F/t/T motion backward

" u                undo
" {Visual}u        lowercase selection
" U                redo
" {Visual}U        uppercase selection
nnoremap U <C-r>

" v                enter visual mode
" V                enter visual line mode
" <C-v>            enter blockwise visual mode
" {Insert}<C-v>    insert a character literal (e.g. <TAB> instead of 2 spaces)

" w                move word forward
" W                move WORD forward

" x                delete char forward, don't save to register
" X                delete char backward, don't save to register
" <C-x>            decrement number under cursor (pairs with <C-a>)
noremap x "_x
noremap X "_X

" y                yank/copy text
" {Visual}y        yank selection, place cursor at end of selection
" Y                join two lines (Y looks like two lines joining into one)
map y <Plug>(highlightedyank)
vnoremap <silent> y y`]
noremap Y J

" z{*}             manage folds
"   zc             close fold
"   zd             delete fold
"   zf             create fold with motion
"   zi             toggle all folds in buffer
"   zo             open fold
" zz               center window on cursor
" ZZ               save and exit
" <C-z>            suspend program

" [{*}             back list entry actions
"   [b, [B         previous, first buffer
"   [l, [L         previous, first location list entry
"   [q, [Q         previous, first quickfix list entry
"   [t, [T         previous, first tag stack entry
"   [s             previous misspelled word
"   [e             previous change list entry
" ]{*}             forward list entry actions
"   ]b, ]B         next, last buffer
"   ]l, ]L         next, last location list entry
"   ]q, ]Q         next, last quickfix list entry
"   ]t, ]T         next, last tag stack entry
"   ]s             next misspelled word
"   ]e             next change list entry
" [y{motion}       encode string with c-style escape sequences
" ]y{motion}       decode string with c-style escape sequences
" [<space>         insert [count] blank line(s) above
" ]<space>         insert [count] blank line(s) below
" <A-[>            previous jump list location
" <A-]>            next jump list location
" <C-]>            follow ctag
" <C-[>            <ESC>
nnoremap [e g;
nnoremap ]e g,
nnoremap <A-[> <C-o>
nnoremap <A-]> <C-i>

" 0                go to first character of line
" ^                go to start of line
" $                go to end of line
nnoremap 0 ^
nnoremap ^ 0

" %                jump to matching brace/bracket/paren

" :                enter command mode
" ;                enter command mode
nnoremap ; :
vnoremap ; :

" {                jump to beginning of paragraph
" }                jump to end of paragraph

" /                search
" ?                search backwards

" *                search for word under cursor forward
" {Visual}*        search for selection forward
" #                search for word under cursor backwards
" {Visual}#        search for selection backward

" >>               indent line
" {Visual}>        indent selection
" <<               un-indent line
" {Visual}<        un-indent selection
" ==               auto indent
" {Visual}=        auto indent selection

" "{r}{y/d/c/p}    use register {r} for next yank, delete, or paste
" "{r}{y/d/c/p}    store text to register {r} for next yank or delete
" ""               default register, '""y' is equivalent to 'y'
" "{a-z}           named registers for manual use
" "_               black hole/trash register
" ".               contains last inserted text
" "%               contains name of current file
" "#               contains name of alternate file
" ":               contains most recently executed command
" "/               contains last search

" '{a-Z}           jump to mark {a-Z}, start of line
" `{a-Z}           jump to mark {a-Z}, line and column position

" .                repeat last command
" {Visual}.        repeat last command once on each line
vnoremap . :norm.<CR>

" -                open Dirvish in file's directory
" {Dirvish}-       move up to the parent directory
" {Dirvish}q       return to buffer dirvish was called from
" {Dirvish}<CR>    go to directory/edit file under cursor

" <Tab>            indent line/selection
" <S-Tab>          un-indent line/selection
" {Insert}<Tab>    show completion menu, scroll down through menu
" {Insert}<S-Tab>  if the completion menu is open scroll up, else insert a tab
nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab> >
vnoremap <S-Tab> <
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : deoplete#mappings#manual_complete()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>"


"===============================================================================
" Leader Bindings
" General convenience bindings -- search and navigation with fzf, git
" integration with fugitiveand magit, window management, useful odds and ends.
"===============================================================================

" Leader
let g:mapleader = "\<Space>"

" <Leader>a  fzf search with ag (search all text in project)
" <Leader>A  fzf search with ag, full screen with preview
nnoremap <silent> <Leader>a :execute 'Ag ' . input('Ag: ')<CR>
nnoremap <silent> <Leader>A :execute 'Ag! ' . input('Ag!: ')<CR>

" <Leader>b  fzf search buffer list
nnoremap <silent> <Leader>b :Buffers<CR>

" <Leader>c  close focused window
nnoremap <Leader>c <C-w><C-q>

" <Leader>d  delete this buffer from buffer list, keep window if possible
nnoremap <Leader>d :bp<bar>sp<bar>bn<bar>bd<CR>

" <Leader>e  edit any file, fzf search all files under home (except hidden dirs)
nnoremap <silent> <Leader>e :Files ~<CR>

" <Leader>f  TODO

" <Leader>g{*}  git bindings
"   <Leader>gb  fugitive git blame
"   <Leader>gc  fzf search git commits
"   <Leader>gd  fugitive git diff
"   <Leader>gh  fzf search git commits for buffer (buffer's git history)
"   <Leader>gm  open magit in current buffer
"   <Leader>gf  fzf search all files in current git repo
"   <Leader>gs  fzf search `git status`, meaning files with unstaged changes
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>gc :Commits<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gh :BCommits<CR>
nnoremap <silent> <Leader>gm :MagitOnly<CR>
nnoremap <silent> <Leader>gf :GFiles<CR>
nnoremap <silent> <Leader>gs :GFiles?<CR>

" <Leader>h  fzf search recently opened files history
" <Leader>H  swap window left
nnoremap <silent> <Leader>h :History<CR>
nnoremap <Leader>H <C-w>H

" <Leader>i  linting info related to error on line
" <Leader>I  show vim syntax highlighting groups for word under cursor
nnoremap <Leader>i :ALEDetail<CR>
nnoremap <Leader>I :call <SID>SynStack()<CR>

" <Leader>j  TODO
" <Leader>J  swap window down
nnoremap <Leader>J <C-w>J

" <Leader>k  TODO
" <Leader>K  swap window up
nnoremap <Leader>K <C-w>K

" <Leader>l  toggle location list, using ListToggle plugin
" <Leader>L  swap window right
nnoremap <Leader>L <C-w>L

" <Leader>m  jump to mark M
nnoremap <Leader>m 'M

" <Leader>n  jump to mark N
nnoremap <Leader>n 'N

" <Leader>o  TODO

" <Leader>p  fzf search current project, meaning current git repo
nnoremap <silent> <Leader>p :GFiles<CR>

" <Leader>q  toggle the quickfix list, using ListToggle plugin

" <Leader>r             TODO

" <Leader>s  TODO

" <Leader>t{*}  test bindings
"   <Leader>tt  test this (run test under cursor)
"   <Leader>tf  test file
"   <Leader>ts  test suite
"   <Leader>tl  test last
"   <Leader>tg  test go (return to last ran test)
nnoremap <silent> <leader>tt :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>ts :TestSuite<CR>
nnoremap <silent> <leader>tl :TestLast<CR>
nnoremap <silent> <leader>tg :TestVisit<CR>

" <Leader>u  toggle undotree
nnoremap <Leader>u :UndotreeToggle<CR>

" <Leader>v  vertical split
" <Leader>V  horizontal split
noremap <Leader>v :vsplit<CR>
noremap <Leader>V :split<CR>

" <Leader>w         wrap/reformat the current line TODO: don't use this
" {Visual}<Leader>w wrap/reformat selection
nnoremap <Leader>w gqq
vnoremap <Leader>w gq

" <Leader>x  TODO

" <Leader>y{c}  surround a word with {c} (weak mnemonic is You surround word)
" <Leader>Y{c}  surround a WORD with {c}
nnoremap <Leader>y <ESC>:execute "normal \<Plug>Ysurround"<CR>g@iw
nnoremap <Leader>Y <ESC>:execute "normal \<Plug>Ysurround"<CR>g@iW

" <Leader>z  fzf search ctags (ctag[z])
" <Leader>Z  fzf search helptags (helptag[Z])
nnoremap <silent> <Leader>z :Tags<CR>
nnoremap <silent> <Leader>Z :Helptags<CR>

" <Leader>=  resize windows to split evenly
nnoremap <Leader>= <C-w>=

" <Leader>|  vertical split
" <Leader>_  horizontal split
noremap <Leader><Bar> :vsplit<CR>
noremap <Leader>_ :split<CR>

" <Leader>/  fzf search current buffer
" <Leader>*  fzf search current buffer for text under cursor
nnoremap <Leader>/ :BLines<CR>
nnoremap <Leader>* :BLines <C-r><C-w><CR>

" <Leader><Leader>  switch between current and last buffer
nnoremap <Leader><Leader> <c-^>

" <Leader><TAB>        TODO

" {Term}<Leader><ESC>  switch from terminal mode to reading terminal as buffer
tnoremap <Leader><ESC> <C-\><C-n>


"===============================================================================
" Local Leader Bindings
" Bindings for specific file types.
"===============================================================================

let g:maplocalleader = ','

" Elm
" These commands require that the vim root directory is also the base
" directory of the elm project. If vim is opened from 'src/' then elm-make and
" elm-oracle will fail.
" <LocalLeader>m  compile current buffer
" <LocalLeader>M  compile project
" <LocalLeader>t  run tests (TODO: how is this different from vim-test?)
" <LocalLeader>f  format file
" <LocalLeader>d  shows the docs for the word under the cursor
" <LocalLeader>D  opens web browser to docs for the word under the cursor
autocmd vimrc FileType elm nmap <LocalLeader>m <Plug>(elm-make)
autocmd vimrc FileType elm nmap <LocalLeader>M <Plug>(elm-make-main)
autocmd vimrc FileType elm nmap <LocalLeader>t <Plug>(elm-test)
autocmd vimrc FileType elm nmap <LocalLeader>f :ElmFormat<CR>
autocmd vimrc FileType elm nmap <LocalLeader>d <Plug>(elm-show-docs)
autocmd vimrc FileType elm nmap <LocalLeader>D <Plug>(elm-browse-docs)

" Clojure
" <LocalLeader>r  require the current namespace so it's updated in the nREPL
" <LocalLeader>R  require the current namespace with the :reload-all flag
" <LocalLeader>e  evaluate the innermost form under cursor
" <LocalLeader>E  evaluate the outermost form under cursor
" <LocalLeader>f  format file
" <LocalLeader>d  show docs for token under cursor
" <LocalLeader>s  show source for token under cursor
autocmd vimrc FileType clojure nmap <LocalLeader>r :Require<CR>
autocmd vimrc FileType clojure nmap <LocalLeader>R :Require!<CR>
autocmd vimrc FileType clojure nmap <LocalLeader>e cpp
autocmd vimrc FileType clojure nmap <LocalLeader>E :Eval<CR>
autocmd vimrc FileType clojure nmap <LocalLeader>f :Cljfmt<CR>
autocmd vimrc FileType clojure nmap <LocalLeader>d :Doc <C-r><C-w><CR>
autocmd vimrc FileType clojure nmap <LocalLeader>s :Source <C-r><C-w><CR>


"===============================================================================
" Text Objects
" Note that the 's' sentence text object have been re-mapped to 'S', and the
" original bindings have been repurposed for variable segments/sections.
"===============================================================================

" i{*}             inner/inside text object
" a{*}             a/all of text object, includes surrounding whitespace
"   c              comment
"   e              entire buffer
"   l              line
"   p              paragraph
"   s              variable segment, either snake_case or camelCase
"   S              sentence
"   t              html tags
"   w              word
"   W              WORD
"   [ or ], ( or ),
"   < or >, { or } matching pairs
"   `, ", '        matching quotes
onoremap <silent> iS is
xnoremap <silent> iS is
onoremap <silent> aS as
xnoremap <silent> aS as
omap <silent> is <Plug>CamelCaseMotion_iw
xmap <silent> is <Plug>CamelCaseMotion_iw
omap <silent> as <Plug>CamelCaseMotion_iw
xmap <silent> as <Plug>CamelCaseMotion_iw


"===============================================================================
" Commands
" Features that I don't use enough to motivate key bindings and custom
" function bindings.
"===============================================================================

" Highlight the color column, defaults to col 81 if nothing else is set
command! TCC call <SID>ToggleColorColumn()

" Download the vim-plug package manager
command! DownloadPlug call <SID>DownloadPlug()

" Toggle Neoformat so that it doesn't run on every save
command! NeoformatToggle call <SID>NeoformatToggle()

" Run Neoformat as long as NeoformatToggle has not disabled it
command! NeoformatIfEnabled call <SID>NeoformatIfEnabled()

" When running Ag through fzf, don't include the file path when filtering.
" Also show a preview window when doing a fullscreen Ag! search.
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%')
  \                         : {'options': '--delimiter : --nth 4..'},
  \                 <bang>0)

" Plug starts with ':Plug*', includes Install, Clean, Update, Upgrade.

" Git starts with ':G*', includes blame, diff. Use ':GV' to view git history.

" Unix utilities include ':Move', ':Rename', ':Delete', ':Mkdir'. Note that
" ':SudoEdit' and ':SudoWrite' are broken in nvim.

" Rails
" ':Rpreview' open webpage, ':A' edit 'alternate' file (usually test)
" ':R' edit 'related' file (depends), editing specific files starts with ':E*'

" Linting starts with ':ALE*', includes Lint, Toggle, Detail, Info.


"===============================================================================
" All the Little Things
"===============================================================================

set showcmd                  " show command in status line as it is composed
set showmatch                " highlight matching brackets
set showmode                 " show current mode
set number                   " line numbers on the left side
set numberwidth=4            " left side number column is 4 characters wide
set expandtab                " insert spaces when TAB is pressed
set tabstop=2                " render TABs using this many spaces
set shiftwidth=2             " indentation amount for < and > commands
set noerrorbells             " no beeps
set nomodeline               " disable modeline
set nojoinspaces             " prevents inserting two spaces on a join (Y)
set ignorecase               " make searching case insensitive...
set smartcase                " ... unless the query has capital letters
set nowrap                   " don't wrap text, use 'cow' to toggle line wrap
set list                     " highlight tabs and trailing spaces
set listchars=tab:>·,trail:· " symbols to display for tabs and trailing spaces
set scrolloff=3              " show next 3 lines while scrolling
set sidescrolloff=5          " show next 5 columns while side-scrolling
set splitbelow               " horizontal split opens under active window
set splitright               " vertical split opens to right of active window
set shortmess+=I             " Don't show the intro
set bufhidden=hide           " allow switching from an unsaved buffer
set autowrite                " auto write file when switching buffers
set wildmode=longest:full    " bash-style command mode completion
set fillchars=vert:\|        " use vertical bars to divide windows
set completeopt=menuone      " show completion menu even if there's only one opt
set completeopt+=noinsert    " ... and prevent automatic text injection
set completeopt+=preview     " ... and prevent automatic text injection
set matchpairs+=<:>          " highlight matching angle brackets


"===============================================================================
" Metadata Files
" In general neovim stores metadata files in '$XDG_DATA_HOME/nvim/*', which
" most likely resolves to '~/.local/share/nvim/*'.
"===============================================================================

" don't save file backups, but if backups are saved, don't co-locate them with
" the original file, use '~/.local/share/nvim/backup//' instead
set nobackup
set backupdir-=.
" unlike with swap, undo, and shada, nvim won't auto-mkdir for backups
if !isdirectory(expand(&backupdir))
  call mkdir(expand(&backupdir), 'p')
endif

" save swap files to '~/.local/share/nvim/swap//'
set swapfile

" save undo history files to '~/.local/share/nvim/undo//'
set undofile

" Use the default setting for the shada (shared data) file. See ':h 'shada''
" for details. Saves to '~/.local/share/nvim/shada/main.shada'.


"===============================================================================
" Filetype Settings
" Most filetypes are dealt with by plugins, here's what's left.
"===============================================================================

" text: wrap at 80 characters
autocmd vimrc FileType text setlocal textwidth=80
autocmd vimrc FileType markdown setlocal textwidth=80

" vim: reload vimrc every time this buffer is saved
autocmd vimrc BufWritePost $MYVIMRC source $MYVIMRC

" elm: use 4 spaces to indent
autocmd vimrc FileType elm setlocal tabstop=4
autocmd vimrc FileType elm setlocal shiftwidth=4

" python: tab nonsense
autocmd vimrc FileType python setlocal noexpandtab
autocmd vimrc FileType python setlocal tabstop=8
autocmd vimrc FileType python setlocal softtabstop=8

" git: wrap at 72 characters
autocmd FileType gitcommit set textwidth=72
autocmd FileType magit set textwidth=72


"===============================================================================
" Helper Functions
" Hide these at the bottom. :)
"===============================================================================

" download the vim-plug package manager
function! <SID>DownloadPlug()
  let l:file = expand(g:nvim_config_dir . '/autoload/plug.vim')
  if !filereadable(l:file)
    execute '!curl -fLo ' . l:file . ' --create-dirs' . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    echo 'Plug downloaded to ' . l:file
  else
    echo 'Plug is already downloaded to ' . l:file
  endif
endfunction

" vim theme building helper
function! <SID>SynStack()
  if !exists('*synstack')
    return
  endif
  echo map(synstack(line('.'), col('.')), "synIDattr(v:val, 'name')")
endfunc

function! <SID>ToggleColorColumn()
  if &colorcolumn !=? ''
    setlocal colorcolumn&
  else
    setlocal colorcolumn=81
  endif
endfunc

function! <SID>NeoformatToggle()
  if !exists('b:disable_neoformat_in_buffer')
    let b:disable_neoformat_in_buffer = 1
  else
    let b:disable_neoformat_in_buffer = !b:disable_neoformat_in_buffer
  endif
  echo('Neoformat ' . (b:disable_neoformat_in_buffer ? 'disabled' : 'enabled'))

  return b:disable_neoformat_in_buffer
endfunction

function! <SID>NeoformatIfEnabled()
  if !exists('b:disable_neoformat_in_buffer') || !b:disable_neoformat_in_buffer
    Neoformat
  endif
endfunction

function! StatuslineALE()
  let l:issues = ale#statusline#Count(bufnr('%'))
  if l:issues.total > 0
    if l:issues.error > 0
      return 'ERRORS: ' . l:issues.error
    elseif l:issues.warning > 0
      return 'WARNINGS: ' . l:issues.warning
    elseif (l:issues.style_error + l:issues.style_warning) > 0
      return 'STYLE: ' . (l:issues.style_error + l:issues.style_warning)
    elseif l:issues.info > 0
      return 'INFO: ' . l:issues.info
    endif
  endif

  return ''
endfunction

function! MyTabLine()
  let l:s = ''
  for l:i in range(tabpagenr('$'))
    " highlight the open tabpage
    if l:i + 1 == tabpagenr()
      let l:s .= '%#TabLineSel#'
    else
      let l:s .= '%#TabLine#'
    endif

    " list the filename of the selected window in each tabpage
    let l:s .= '  %{MyTabLabel(' . (l:i + 1) . ')}  '
  endfor

  " after the last tabpage blank out the rest of the line
  let l:s .= '%#TabLineFill#'

  return l:s
endfunction

function! MyTabLabel(n)
  let l:buflist = tabpagebuflist(a:n)
  let l:winnr = tabpagewinnr(a:n)
  return fnamemodify(bufname(l:buflist[l:winnr - 1]), ':t')
endfunction
