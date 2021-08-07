--[[----------------------------------------------------------------------------
Plugins

Load and configure plugin.

External dependencies:
- FZF, SearchReplace: Install Ripgrep.
- lspconfig and null-ls: Make sure desired servers, formatters and linters are
  available as global executables. This can be done through per-project
  nix-shells.
- ALE: Install linters for regularly used languages. Use ':ALEInfo' on a file to
  find out about linting that file type.
- Gutentags: Install Universal Ctags.
------------------------------------------------------------------------------]]

local Plugins = {}

Plugins.config = {}

Plugins.config.packer = {
  compile_path = require('em.lua').join_paths(
    vim.fn.stdpath('config'),
    'lua',
    'em',
    'packer_compiled.lua'
  ),
  disable_commands = true,
}

Plugins.config.specs = {
  -- Manage plugins
  'wbthomason/packer.nvim',

  -- Helpers for configuring vim using lua.
  'nvim-lua/popup.nvim',
  'nvim-lua/plenary.nvim',
  'tjdevries/astronauta.nvim',

  -- Search and navigate with fuzzy find
  -- Open fzf in a terminal buffer, with values loaded in from different sources.
  -- <Leader>a        search all text in project
  -- <Leader>A        search all text in project, full screen
  -- <Leader>b        search buffer list
  -- <Leader>e        search everything on disk (like ':e /foo/bar')
  -- <Leader>f        search file paths, insert selected file path into buffer
  -- <Leader>gc       search git commits
  -- <Leader>gf       search all files in current git repo (alias '<Leader>p')
  -- <Leader>gh       search git commits for buffer (buffer's git history)
  -- <Leader>gs       search `git status`, meaning files with unstaged changes
  -- <Leader>h        search recently opened files history
  -- <Leader>p        search project files, meaning files in root dir git repo
  -- <Leader>z        search ctags (ctag[z])
  -- <Leader>Z        search helptags (helptag[Z])
  -- <Leader>/        search text in current buffer
  -- <Leader>*        search text in current buffer for word under cursor
  -- <Leader><TAB>    search mappings in normal/visual/pending mode
  -- {FZF}<TAB>       select multiple results to open
  -- {FZF}<C-t>       open in new tab
  -- {FZF}<C-s>       open in horizontal split
  -- {FZF}<C-v>       open in vertical split
  {
    'junegunn/fzf.vim',
    requires = { 'junegunn/fzf' },
    config = function()
      vim.g.fzf_action = {
        ['ctrl-t'] = 'tab split',
        ['ctrl-s'] = 'split',
        ['ctrl-v'] = 'vsplit',
      }
      vim.g.fzf_layout = {
        window = {
          width = 1.0,
          height = 0.4,
          yoffset = 0.99,
          border = 'top',
        },
      }
    end,
  },

  -- Search and navigate with fuzzy find
  {
    'nvim-telescope/telescope.nvim',
    cmd = { 'Telescope' },
    config = function()
      require('telescope').setup({
        defaults = {
          sorting_strategy = 'ascending',
          preview_title = '',

          layout_strategy = 'bottom_pane',
          layout_config = {
            height = 0.35,
          },

          border = true,
          borderchars = {
            '',
            prompt = { '─', ' ', ' ', ' ', '─', '─', ' ', ' ' },
            results = { ' ' },
            preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
          },
        },
      })
    end,
  },

  -- TODO
  {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = false,
          presets = true,
        },
        key_labels = {
          ['<space>'] = 'SPC',
          ['<cr>'] = 'RET',
          ['<tab>'] = 'TAB',
          ['<esc>'] = 'ESC',
        },
        ignore_missing = false,
        triggers = { '<leader>', "'", '"', 'g', 'z' },
      })
    end,
  },

  -- TODO
  'neovim/nvim-lspconfig',

  -- LSP tool integration
  -- Run code formatters, linters, and other tools via LSP.
  -- cof                                enable/disable formatting on save
  -- :Format                            run formatting on the current buffer
  -- {Visual}:Format                    run formatting on selection
  {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { 'neovim/nvim-lspconfig', 'nvim-lua/plenary.nvim' },
  },

  -- TODO
  {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup({
        fold_open = 'v',
        fold_closed = '>',
        indent_lines = false,
        icons = false,
        signs = {
          error = 'error',
          warning = 'warn',
          hint = 'hint',
          information = 'info',
        },
        use_lsp_diagnostic_signs = false,
      })
    end,
  },

  -- Completion
  -- Manually activated completion suggestions.
  -- {Insert}<TAB>    open the popup menu with autocomplete suggestions
  -- {PUM}<TAB>       scroll down through the popup menu
  -- {PUM}<S-TAB>     scroll up through the popup menu
  -- {PUM}<CR>        insert current popup menu selection
  -- {PUM}<ESC>       cancel completion
  {
    'hrsh7th/nvim-compe',
    event = 'InsertEnter',
    config = function()
      require('compe').setup({
        enabled = true,
        autocomplete = false,
        documentation = false,
        source = {
          path = true,
          buffer = true,
          tags = true,
          spell = false,
          calc = false,
          omni = false,
          emoji = false,
          nvim_lsp = true,
          nvim_lua = true,
        },
      })
    end,
  },

  -- Auto generate and manage ctags
  -- Requires some version of ctags, such as Exuberant Ctags or Universal Ctags.
  -- In order to generate tags Gutentags needs to know the root directory of the
  -- current project. If you use version management then the project root should
  -- be detected automatically. If you don't use version management then you'll
  -- have to read the docs. If the project uses Git or Mercurial then tags will
  -- only be generated for tracked files.
  {
    'ludovicchabant/vim-gutentags',
    config = function()
      vim.g.gutentags_file_list_command = {
        markers = { ['.git'] = 'git ls-files', ['.hg'] = 'hg files' },
      }
    end,
  },

  -- Git integration
  -- Commands all start with ':G*'.
  -- gb               git blame in buffer
  -- <Leader>gb       git blame in buffer
  -- <Leader>gd       git diff on buffer
  -- <Leader>gs       git status display
  'tpope/vim-fugitive',

  -- Browse Git history
  -- Relies on fugitive.
  -- :GV             view history for the current branch in a new tabpage
  -- :GV!            view history for the current file in a new tabpage
  -- :GV?            popuilate location list with file-specific commits
  -- gt              go to next tabpage
  -- gT              go to previous tabpage
  'junegunn/gv.vim',

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
  'jreybert/vimagit',

  -- Simple file browser
  -- View and navigate directories. The name of the Dirvish buffer is always set
  -- to the current file path, so the % register can be used for file operations
  -- such as `:!mkdir %foodir`, `:e %foo.txt`, or `:!rm %foo.txt`.
  -- -                open Dirvish in file's directory
  -- {Dirvish}-       move up to the parent directory
  -- {Dirvish}q       return to buffer dirvish was called from
  -- {Dirvish}<CR>    go to directory/edit file under cursor
  -- {Dervish}L       show file info, like `ls -l`
  {
    'justinmk/vim-dirvish',
    config = function()
      vim.g.dirvish_mode = ':sort ,^.*[/],' -- show directories first
    end,
  },

  -- Multi-file search/replace
  -- Perform a substitution across multiple files
  -- :Search          open the prompt window to enter a search pattern
  -- :Search pattern  search for a find/replace pattern to stage
  -- :Replace newStr  Complete the replacement on staged search results
  -- {SearchReplace}d delete a line/file from the staged results
  'romgrk/searchReplace.vim',

  -- Smart commenting
  -- gc{motion}       toggle commenting on lines that {motion} moves over
  -- gcc              comment/uncomment line
  'tpope/vim-commentary',

  -- Make plugins like surround and unimpaired work with the '.' repeat command
  'tpope/vim-repeat',

  -- Manipulate surrounding pairs
  -- cs{c1}{c1}            change surrounding chars from {c1} to {c2}
  -- ds{c}                 delete surrounding chars {c}
  -- ys{motion}{c}         add new surrounding chars {c}
  -- {Visual}vs{c}         surround visual selection with {c}
  -- <Leader>y{c}          surround word under cursor with {c}
  -- <Leader>Y{c}          surround WORD under cursor with {c}
  -- {Visual}<Leader>y{c}  surround visual selection with {c}
  'tpope/vim-surround',

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
  --   cxD            to DOT.CASE
  --   cxw            to word case
  --   cxW            to WORD CASE
  --   cxt            to Title Case
  -- <Leader>x{*}     change case for word under the cursor, as with cx{*}iw
  -- <Leader>X{*}     change case for WORD under the cursor, as with cx{*}iW
  {
    'mulias/vim-caser',
    config = function()
      vim.g.caser_prefix = 'cx'
      vim.g.caser_custom_mappings = {
        CamelCase = { 'c' },
        MixedCase = { 'C' },
        SnakeCase = { 's' },
        UpperCase = { 'S' },
        KebabCase = { 'k' },
        KebabCapsCase = { 'K' },
        DotCase = { 'd' },
        DotCapsCase = { 'D' },
        SpaceCase = { 'w' },
        SpaceCapsCase = { 'W' },
        TitleCase = { 't' },
        SentenceCase = {},
      }
    end,
  },

  -- Repeat find and 'till easily
  -- f or t           repeat last f/F/t/T motion forward
  -- F or T           repeat last f/F/t/T motion backward
  {
    'rhysd/clever-f.vim',
    config = function()
      vim.g.clever_f_fix_key_direction = 1
    end,
  },

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
  'tpope/vim-unimpaired',

  -- Unix file management integration
  -- Includes ':Move', ':Rename', ':Delete', ':Mkdir'. Note that ':SudoEdit'
  -- and ':SudoWrite' are broken in nvim.
  'tpope/vim-eunuch',

  -- Read/Write protected files
  -- Alternative to ':SudoEdit' and ':SudoWrite'. Automatically runs when a new
  -- protected file is opened.
  -- :SudoEdit        open the current file with sudo
  -- :SudoEdit foo    open the file foo with sudo
  -- :SudoWrite       save the current file with sudo
  -- :SudoWrite foo   write to foo with sudo
  {
    'lambdalisue/suda.vim',
    config = function()
      vim.g.suda_smart_edit = 1
    end,
  },

  -- Better in-buffer search defaults
  -- Remove highlight after moving cursor, allow * search for selection.
  -- {Visual}*        search for selection forward
  -- {Visual}#        search for selection backward
  'junegunn/vim-slash',

  -- View and navigate the undo tree
  -- <Leader>u        toggle undo tree
  -- {Undotree}?      show hotkeys and quick help
  {
    'mbbill/undotree',
    cmd = { 'UndotreeToggle', 'UndotreeShow' },
    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },

  -- Navigate by variable segments/sections
  -- Move and manipulate sections of camelCase or snake_case variables.
  -- s                move forward one variable segment
  -- S                move back one variable segment
  -- is/as            text object for a variable segment
  -- iS/aS            new mappings for sentence text object
  'bkad/CamelCaseMotion',

  -- Text object after a given character
  -- Operate on text relative to characters specified in the
  -- `after_object#enable` call.
  -- a{c}             text object for part of line after next {c}
  -- aa{c}            text object for part of line after previous {c}
  {
    'junegunn/vim-after-object',
    event = 'VimEnter',
    config = function()
      local chars = { '=', ':', '-', '_', ' ', '#', '?', '$', '!', '&' }
      vim.fn['after_object#enable'](unpack(chars))
    end,
  },

  -- Additional text objects
  -- il/al            text object for text in a line or the whole line
  -- ie/ae            text object for entire buffer, whitespace excluded/included
  -- ic/ac            text object for a comment's contents or the whole comment
  -- Text object: l for a whole line or text in a line
  { 'kana/vim-textobj-user', event = 'VimEnter' },
  { 'kana/vim-textobj-line', after = { 'vim-textobj-user' } },
  { 'kana/vim-textobj-entire', after = { 'vim-textobj-user' } },
  { 'glts/vim-textobj-comment', after = { 'vim-textobj-user' } },

  -- Show colored backgrounds for hex values and css color functions
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      if vim.o.termguicolors then
        require('colorizer').setup({
          ['*'] = {
            RGB = true,
            RRGGBB = true,
            RRGGBBAA = true,
            names = false,
            rgb_fn = true,
            hsl_fn = true,
            mode = 'background',
          },
        })
      end
    end,
    ft = { 'css', 'scss', 'javascriptreact', 'typescriptreact' },
  },

  -- ColorSchemes
  -- Some nice colorschemes, most of which require true color.
  'iCyMind/NeoSolarized',
  'rakr/vim-two-firewatch',
  'rakr/vim-colors-rakr',
  'reedes/vim-colors-pencil',
  'owickstrom/vim-colors-paramount',
  'shaunsingh/moonlight.nvim',

  -- Auto-resize windows
  -- Make sure the focused window is at least 85 cols wide, while equalizing
  -- the width of all other windows.
  {
    'beauwilliams/focus.nvim',
    config = function()
      require('focus').width = 85
    end,
  },

  -- Filetype defaults
  -- Set highlighting and defaults for rarely used languages.
  {
    'sheerun/vim-polyglot',
    setup = function()
      vim.g.polyglot_disabled = { 'lua' }
    end,
  },
}

function Plugins.manage()
  local packer = require('packer')

  packer.startup({
    Plugins.config.specs,
    config = Plugins.config.packer,
  })

  return packer
end

function Plugins.setup()
  require('em.packer_compiled')
end

function Plugins.reload()
  package.loaded['em.packer_compiled'] = nil
  return require('em.lua').reload('em.config.plugins')
end

return Plugins
