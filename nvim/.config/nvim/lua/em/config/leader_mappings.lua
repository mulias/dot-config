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
  a = {
    function()
      vim.fn.execute('Rg ' .. vim.fn.input('Search project for: '))
    end,
    'search all in project',
  },
  A = {
    function()
      vim.fn.execute('Rg! ' .. vim.fn.input('Search project for: '))
    end,
    'search all in project, full screen',
  },
  b = { '<Cmd>Buffers<CR>', 'search buffer list' },
  c = { '<C-w><C-q>', 'close focused window' },
  C = { '<Cmd>Colors<CR>', 'change colorscheme' },
  d = { vim.diagnostic.setloclist, 'file diagnostics' },
  D = { vim.diagnostic.setqflist, 'project diagnostics' },
  -- e
  -- f = { name = 'finders' },
  g = {
    name = 'git',
    b = { '<Cmd>Git blame<CR>', 'git blame' },
    h = { '<Cmd>BCommits<CR>', 'search git history for buffer' },
    m = { '<Cmd>MagitOnly<CR>', 'open magit in current buffer' },
    s = { '<Cmd>GFiles?<CR>', 'search git unstaged files' },
  },
  h = { '<Cmd>History<CR>', 'search recent file history' },
  i = { vim.diagnostic.open_float, 'diagnostics info for line' },
  -- j
  k = { vim.lsp.buf.hover, 'keyword info, using lsp hover' },
  ['nx K'] = { 'K', 'keyword info, using keywordprg' },
  l = { vim.fn.ToggleLocationList, 'toggle location list' },
  m = { "'M", 'jump to mark M' },
  n = { "'N", 'jump to mark N' },
  o = {
    name = 'toggle options',
    b = { 'cob', 'toggle background', noremap = false, silent = false },
    f = { 'cof', 'toggle format on write', noremap = false, silent = false },
    h = {
      'coh',
      'toggle search highlight',
      noremap = false,
      silent = false,
    },
    i = { 'coi', 'toggle indent guides', silent = false },
    n = { 'con', 'toggle line numbers', noremap = false, silent = false },
    r = {
      'cor',
      'toggle relative line numbers',
      noremap = false,
      silent = false,
    },
    s = { 'cos', 'toggle spellcheck', noremap = false, silent = false },
    w = { 'cow', 'toggle line wrap', noremap = false, silent = false },
    y = {
      'coy',
      'toggle highlight on yank',
      noremap = false,
      silent = false,
    },
    ['|'] = {
      'co|',
      'toggle 80 character line',
      noremap = false,
      silent = false,
    },
    ['-'] = { 'co-', 'toggle cursorline', noremap = false, silent = false },
    ['='] = {
      'co=',
      'toggle window auto-resize',
      noremap = false,
      silent = false,
    },
  },
  p = { '<Cmd>GFiles<CR>', 'search project' },
  q = { vim.fn.ToggleQuickfixList, 'toggle quickfix list' },
  r = { vim.lsp.buf.references, 'populate quickfix with references' },
  R = { vim.lsp.buf.rename, 'rename variable' },
  ['n s'] = {
    ':%s/<C-r><C-w>/',
    'search/replace word in buffer',
    silent = false,
  },
  ['x s'] = {
    '"sy:%s/<C-r>s/',
    'search/replace visual selection in buffer',
    silent = false,
  },
  S = { ':Search ', 'search/replace in project', silent = false },
  -- t
  u = { '<Cmd>UndotreeToggle<CR>', 'toggle undotree' },
  v = { '<Cmd>vsplit<CR>', 'vertical split' },
  V = { '<Cmd>split<CR>', 'horizontal split' },
  w = {
    name = 'window',
    c = { '<C-w><C-q>', 'close window' },
    h = { '<C-w>H', 'swap window left' },
    j = { '<C-w>J', 'swap window down' },
    k = { '<C-w>K', 'swap window up' },
    l = { '<C-w>L', 'swap window right' },
    ['='] = { '<C-w>=', 'size windows evenly' },
  },
  ['n x'] = {
    name = 'change case for word',
    c = { 'cxciw', 'to camelCase', noremap = false },
    C = { 'cxCiw', 'to CamelCase', noremap = false },
    s = { 'cxsiw', 'to snake_case', noremap = false },
    S = { 'cxSiw', 'to SNAKE_CASE', noremap = false },
    k = { 'cxkiw', 'to kabab-Case', noremap = false },
    K = { 'cxKiw', 'to Kabab-Case', noremap = false },
    d = { 'cxdiw', 'to dot.case', noremap = false },
    D = { 'cxDiw', 'to DOT.CASE', noremap = false },
    w = { 'cxwiw', 'to word case', noremap = false },
    W = { 'cxWiw', 'to WORD CASE', noremap = false },
    t = { 'cxtiw', 'to Title Case', noremap = false },
    l = { 'cxliw', 'to lowercase', noremap = false },
    U = { 'cxUiw', 'to UPERCASE', noremap = false },
  },
  ['x x'] = {
    name = 'change case for selection',
    c = { 'cxc', 'to camelCase', noremap = false },
    C = { 'cxC', 'to CamelCase', noremap = false },
    s = { 'cxs', 'to snake_case', noremap = false },
    S = { 'cxS', 'to SNAKE_CASE', noremap = false },
    k = { 'cxk', 'to kabab-Case', noremap = false },
    K = { 'cxK', 'to Kabab-Case', noremap = false },
    d = { 'cxd', 'to dot.case', noremap = false },
    D = { 'cxD', 'to DOT.CASE', noremap = false },
    w = { 'cxw', 'to word case', noremap = false },
    W = { 'cxW', 'to WORD CASE', noremap = false },
    t = { 'cxt', 'to Title Case', noremap = false },
    l = { 'cxl', 'to lowercase', noremap = false },
    U = { 'cxU', 'to UPERCASE', noremap = false },
  },
  X = {
    name = 'change case for WORD',
    c = { 'cxciW', 'to camelCase', noremap = false },
    C = { 'cxCiW', 'to CamelCase', noremap = false },
    s = { 'cxsiW', 'to snake_case', noremap = false },
    S = { 'cxSiW', 'to SNAKE_CASE', noremap = false },
    k = { 'cxkiW', 'to kabab-Case', noremap = false },
    K = { 'cxKiW', 'to Kabab-Case', noremap = false },
    d = { 'cxdiW', 'to dot.case', noremap = false },
    D = { 'cxDiW', 'to DOT.CASE', noremap = false },
    w = { 'cxwiW', 'to word case', noremap = false },
    W = { 'cxWiW', 'to WORD CASE', noremap = false },
    t = { 'cxtiW', 'to Title Case', noremap = false },
    l = { 'cxliW', 'to lowercase', noremap = false },
    U = { 'cxUiW', 'to UPERCASE', noremap = false },
  },
  ['n y'] = { 'ysiw', 'surround word', noremap = false },
  ['x y'] = { '<Plug>VSurround', 'surround selection' },
  Y = { 'ysiW', 'surround WORD', noremap = false },
  z = { '<Cmd>Tags<CR>', 'search ctags' },
  Z = { '<Cmd>Helptags<CR>', 'search helptags' },
  ['='] = { '<C-w>=', 'size windows evenly' },
  ['|'] = { '<Cmd>vsplit<CR>', 'vertical split' },
  ['-'] = { '<Cmd>split<CR>', 'horizontal split' },
  ['/'] = { '<Cmd>BLines<CR>', 'search current buffer' },
  ['*'] = { '<Cmd>BLines <C-r><C-w><CR>', 'search current buffer for word' },
  [']'] = { vim.lsp.buf.definition, 'goto definition' },
  ['<Leader>'] = { '<c-^>', 'switch between current and last buffer' },
  ['t <Esc>'] = { tc('<C-\\><C-n>'), 'leave terminal mode' },
  ['<tab>'] = {
    name = 'LSP actions',
    d = { vim.diagnostic.setloclist, 'file diagnostics' },
    D = { vim.diagnostic.setqflist, 'project diagnostics' },
    r = { vim.lsp.buf.references, 'populate quickfix with references' },
    R = { vim.lsp.buf.rename, 'rename variable' },
    i = { vim.diagnostic.open_float, 'line diagnostics' },
    k = { vim.lsp.buf.hover, 'show hover help' },
    g = { vim.lsp.buf.definition, 'goto definition' },
    [']'] = { vim.lsp.buf.definition, 'goto definition' },
  },
}

function LeaderMappings.setup()
  vim.g.mapleader = LeaderMappings.config.leader

  require('em.vim').map(LeaderMappings.config.mappings, { prefix = '<Leader>' })
end

function LeaderMappings.reload()
  return require('em.lua').reload('em.config.leader_mappings')
end

return LeaderMappings
