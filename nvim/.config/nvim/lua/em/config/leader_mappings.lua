--[[----------------------------------------------------------------------------
Leader Mappings

General convenience bindings -- search and navigation with fzf, git integration
with fugitive and magit, window management, useful odds and ends.

In the config `['nxo foo'] = { ... }` means that the binding `foo` is applied
to normal, visual, and operator pending modes. When there is no mode prefix the
binding is applied to normal mode. See `:h map-modes` for mode abbreviations.
------------------------------------------------------------------------------]]

local LeaderMappings = {}

LeaderMappings.config = {}

local tc = require('em.vim').tc -- escape termcodes

-- Use <Sapce> as the leader key
LeaderMappings.config.leader = ' '

-- Leader key mappings
LeaderMappings.config.mappings = {
  {
    'a',
    function()
      vim.fn.execute('Rg ' .. vim.fn.input('Search project for: '))
    end,
    desc = 'search all in project',
  },
  {
    'A',
    function()
      vim.fn.execute('Rg! ' .. vim.fn.input('Search project for: '))
    end,
    desc = 'search all in project, full screen',
  },
  { 'b', '<Cmd>Buffers<CR>', desc = 'search buffer list' },
  { 'c', '<C-w><C-q>', desc = 'close focused window' },
  { 'C', '<Cmd>Colors<CR>', desc = 'change colorscheme' },
  { 'd', vim.diagnostic.setloclist, desc = 'file diagnostics' },
  { 'D', vim.diagnostic.setqflist, desc = 'project diagnostics' },
  -- e
  -- f

  { 'g', group = 'git' },
  { 'gb', '<Cmd>Git blame<CR>', desc = 'git blame' },
  { 'gh', '<Cmd>BCommits<CR>', desc = 'search git history for buffer' },
  { 'gm', '<Cmd>MagitOnly<CR>', desc = 'open magit in current buffer' },
  { 'gs', '<Cmd>GFiles?<CR>', desc = 'search git unstaged files' },

  { 'h', '<Cmd>History<CR>', desc = 'search recent file history' },
  { 'i', vim.diagnostic.open_float, desc = 'diagnostics info for line' },
  -- j
  { 'k', vim.lsp.buf.hover, desc = 'keyword info, using lsp hover' },
  { 'K', desc = 'keyword info, using keywordprg', mode = { 'n', 'x' } },
  { 'l', vim.fn.ToggleLocationList, desc = 'toggle location list' },
  { 'm', "'M", desc = 'jump to mark M' },
  { 'n', "'N", desc = 'jump to mark N' },

  { 'o', group = 'toggle options' },
  { 'ob', 'cob', desc = 'toggle background', noremap = false, silent = false },
  { 'of', 'cof', desc = 'toggle format on write', noremap = false, silent = false },
  {
    'oh',
    'coh',
    desc = 'toggle search highlight',
    noremap = false,
    silent = false,
  },
  { 'oi', 'coi', desc = 'toggle indent guides', silent = false },
  { 'on', 'con', desc = 'toggle line numbers', noremap = false, silent = false },
  {
    'or',
    'cor',
    desc = 'toggle relative line numbers',
    noremap = false,
    silent = false,
  },
  { 'os', 'cos', desc = 'toggle spellcheck', noremap = false, silent = false },
  { 'ow', 'cow', desc = 'toggle line wrap', noremap = false, silent = false },
  {
    'oy',
    'coy',
    desc = 'toggle highlight on yank',
    noremap = false,
    silent = false,
  },
  {
    'o|',
    'co|',
    desc = 'toggle 80 character line',
    noremap = false,
    silent = false,
  },
  { 'o-', 'co-', desc = 'toggle cursorline', noremap = false, silent = false },
  {
    'o=',
    'co=',
    desc = 'toggle window auto-resize',
    noremap = false,
    silent = false,
  },

  { 'p', '<Cmd>GFiles<CR>', desc = 'search project' },
  { 'q', vim.fn.ToggleQuickfixList, desc = 'toggle quickfix list' },
  { 'r', vim.lsp.buf.references, desc = 'populate quickfix with references' },
  { 'R', vim.lsp.buf.rename, desc = 'rename variable' },
  {
    's',
    ':%s/<C-r><C-w>/',
    desc = 'search/replace word in buffer',
    silent = false,
  },
  {
    's',
    '"sy:%s/<C-r>s/',
    desc = 'search/replace visual selection in buffer',
    silent = false,
    mode = 'x',
  },
  { 'S', ':Search ', desc = 'search/replace in project', silent = false },
  -- t
  { 'u', '<Cmd>UndotreeToggle<CR>', desc = 'toggle undotree' },
  { 'v', '<Cmd>vsplit<CR>', desc = 'vertical split' },
  { 'V', '<Cmd>split<CR>', desc = 'horizontal split' },

  { 'w', group = 'window' },
  { 'wc', '<C-w><C-q>', desc = 'close window' },
  { 'wh', '<C-w>H', desc = 'swap window left' },
  { 'wj', '<C-w>J', desc = 'swap window down' },
  { 'wk', '<C-w>K', desc = 'swap window up' },
  { 'wl', '<C-w>L', desc = 'swap window right' },
  { 'w=', '<C-w>=', desc = 'size windows evenly' },

  { 'x', group = 'change case for word' },
  { 'xc', 'cxciw', desc = 'to camelCase', noremap = false },
  { 'xC', 'cxCiw', desc = 'to CamelCase', noremap = false },
  { 'xs', 'cxsiw', desc = 'to snake_case', noremap = false },
  { 'xS', 'cxSiw', desc = 'to SNAKE_CASE', noremap = false },
  { 'xk', 'cxkiw', desc = 'to kabab-Case', noremap = false },
  { 'xK', 'cxKiw', desc = 'to Kabab-Case', noremap = false },
  { 'xd', 'cxdiw', desc = 'to dot.case', noremap = false },
  { 'xD', 'cxDiw', desc = 'to DOT.CASE', noremap = false },
  { 'xw', 'cxwiw', desc = 'to word case', noremap = false },
  { 'xW', 'cxWiw', desc = 'to WORD CASE', noremap = false },
  { 'xt', 'cxtiw', desc = 'to Title Case', noremap = false },
  { 'xn', 'cxniw', desc = 'to numeronym (n7m)', noremap = false },
  { 'xp', 'cx/iw', desc = 'to path/case', noremap = false },
  { 'xl', 'cxliw', desc = 'to lowercase', noremap = false },
  { 'xU', 'cxUiw', desc = 'to UPERCASE', noremap = false },

  { 'x', group = 'change case for selection', mode = 'x' },
  { 'xc', 'cxc', desc = 'to camelCase', noremap = false, mode = 'x' },
  { 'xC', 'cxC', desc = 'to CamelCase', noremap = false, mode = 'x' },
  { 'xs', 'cxs', desc = 'to snake_case', noremap = false, mode = 'x' },
  { 'xS', 'cxS', desc = 'to SNAKE_CASE', noremap = false, mode = 'x' },
  { 'xk', 'cxk', desc = 'to kabab-Case', noremap = false, mode = 'x' },
  { 'xK', 'cxK', desc = 'to Kabab-Case', noremap = false, mode = 'x' },
  { 'xd', 'cxd', desc = 'to dot.case', noremap = false, mode = 'x' },
  { 'xD', 'cxD', desc = 'to DOT.CASE', noremap = false, mode = 'x' },
  { 'xw', 'cxw', desc = 'to word case', noremap = false, mode = 'x' },
  { 'xW', 'cxW', desc = 'to WORD CASE', noremap = false, mode = 'x' },
  { 'xt', 'cxt', desc = 'to Title Case', noremap = false, mode = 'x' },
  { 'xn', 'cxn', desc = 'to numeronym (n7m)', noremap = false, mode = 'x' },
  { 'xp', 'cx/', desc = 'to path/case', noremap = false, mode = 'x' },
  { 'xl', 'cxl', desc = 'to lowercase', noremap = false, mode = 'x' },
  { 'xU', 'cxU', desc = 'to UPERCASE', noremap = false, mode = 'x' },

  { 'X', group = 'change case for WORD' },
  { 'Xc', 'cxciW', desc = 'to camelCase', noremap = false },
  { 'XC', 'cxCiW', desc = 'to CamelCase', noremap = false },
  { 'Xs', 'cxsiW', desc = 'to snake_case', noremap = false },
  { 'XS', 'cxSiW', desc = 'to SNAKE_CASE', noremap = false },
  { 'Xk', 'cxkiW', desc = 'to kabab-Case', noremap = false },
  { 'XK', 'cxKiW', desc = 'to Kabab-Case', noremap = false },
  { 'Xd', 'cxdiW', desc = 'to dot.case', noremap = false },
  { 'XD', 'cxDiW', desc = 'to DOT.CASE', noremap = false },
  { 'Xw', 'cxwiW', desc = 'to word case', noremap = false },
  { 'XW', 'cxWiW', desc = 'to WORD CASE', noremap = false },
  { 'Xt', 'cxtiW', desc = 'to Title Case', noremap = false },
  { 'Xn', 'cxniW', desc = 'to numeronym (n7m)', noremap = false },
  { 'Xp', 'cx/iW', desc = 'to path/case', noremap = false },
  { 'Xl', 'cxliW', desc = 'to lowercase', noremap = false },
  { 'XU', 'cxUiW', desc = 'to UPERCASE', noremap = false },

  { 'y', 'ysiw', desc = 'surround word', noremap = false },
  { 'y', '<Plug>VSurround', desc = 'surround selection', mode = 'x' },
  { 'Y', 'ysiW', desc = 'surround WORD', noremap = false },
  { 'z', '<Cmd>Tags<CR>', desc = 'search ctags' },
  { 'Z', '<Cmd>Helptags<CR>', desc = 'search helptags' },
  { '=', '<C-w>=', desc = 'size windows evenly' },
  { '|', '<Cmd>vsplit<CR>', desc = 'vertical split' },
  { '-', '<Cmd>split<CR>', desc = 'horizontal split' },
  { '/', '<Cmd>BLines<CR>', desc = 'search current buffer' },
  { '*', '<Cmd>BLines <C-r><C-w><CR>', desc = 'search current buffer for word' },
  { ']', vim.lsp.buf.definition, desc = 'goto definition' },
  { '<Leader>', '<c-^>', desc = 'switch between current and last buffer' },
  { '<Esc>', tc('<C-\\><C-n>'), desc = 'leave terminal mode', mode = 't' },

  { '<tab>', group = 'LSP actions' },
  { '<tab>d', vim.diagnostic.setloclist, desc = 'file diagnostics' },
  { '<tab>D', vim.diagnostic.setqflist, desc = 'project diagnostics' },
  { '<tab>r', vim.lsp.buf.references, desc = 'populate quickfix with references' },
  { '<tab>R', vim.lsp.buf.rename, desc = 'rename variable' },
  { '<tab>i', vim.diagnostic.open_float, desc = 'line diagnostics' },
  { '<tab>k', vim.lsp.buf.hover, desc = 'show hover help' },
  { '<tab>g', vim.lsp.buf.definition, desc = 'goto definition' },
  { '<tab>]', vim.lsp.buf.definition, desc = 'goto definition' },
}

function LeaderMappings.setup()
  vim.g.mapleader = LeaderMappings.config.leader

  local mappings = vim.deepcopy(LeaderMappings.config.mappings)

  for _, mapping in ipairs(mappings) do
    mapping[1] = '<Leader>' .. mapping[1]
  end

  require('which-key').add(mappings)
end

function LeaderMappings.reload()
  return require('em.lua').reload('em.config.leader_mappings')
end

return LeaderMappings
