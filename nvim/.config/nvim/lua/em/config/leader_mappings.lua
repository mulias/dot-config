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
    'search all in project with preview',
  },
  b = { ':Buffers<CR>', 'search buffer list' },
  c = { '<C-w><C-q>', 'close focused window' },
  C = { ':Colors<CR>', 'change colorscheme' },
  d = { ':bp|sp|bn|bd<CR>', 'delete buffer from buffer list' },
  e = { ':Files /<CR>', 'search everything in filesystem' },
  f = {
    'i<Plug>(fzf-complete-file-ag)',
    'search and insert file path',
    noremap = false,
  },
  g = {
    name = 'git',
    b = { ':Gblame<CR>', 'fugitive git blame' },
    c = { ':Commits<CR>', 'search git commits' },
    d = { ':Gdiff<CR>', 'fugitive git diff' },
    f = { ':GFiles<CR>', 'search all files in current git repo' },
    h = { ':BCommits<CR>', 'search git history for buffer' },
    m = { ':MagitOnly<CR>', 'open magit in current buffer' },
    s = { ':GFiles?<CR>', 'search git unstaged files' },
  },
  h = { ':History<CR>', 'search recent file history' },
  -- i
  -- j
  k = { 'K', 'keyword info' },
  -- K
  l = { ':Trouble loclist<CR>', 'toggle location list' },
  m = { "'M", 'jump to mark M' },
  n = { "'N", 'jump to mark N' },
  o = {
    name = 'toggle options',
    b = { 'cob', 'toggle background', noremap = false, silent = false },
    f = { 'cof', 'toggle format on write', noremap = false, silent = false },
    h = { 'coh', 'toggle search highlight', noremap = false, silent = false },
    n = { 'con', 'toggle line numbers', noremap = false, silent = false },
    r = {
      'cor',
      'toggle relative line numbers',
      noremap = false,
      silent = false,
    },
    s = { 'cos', 'toggle spellcheck', noremap = false, silent = false },
    w = { 'cow', 'toggle line wrap', noremap = false, silent = false },
    y = { 'coy', 'toggle highlight on yank', noremap = false, silent = false },
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
  p = { ':GFiles<CR>', 'search project' },
  q = { ':Trouble quickfix<CR>', 'toggle quickfix list' },
  -- r
  R = { ':RefConfig<CR>', 'rerence vimrc config' },
  s = { ':%s/\\<<C-r><C-w>\\>/', 'search/replace word', silent = false },
  S = { ':%s/<C-r><C-w>/', 'search/replace word as substring', silent = false },
  t = {
    name = 'test',
    t = { ':TestNearest<CR>', 'run this test' },
    f = { ':TestFile<CR>', 'run tests in file' },
    s = { ':TestSuite<CR>', 'run tests in suite' },
    l = { ':TestLast<CR>', 'rerun last test' },
    g = { ':TestVisit<CR>', 'go to last test' },
  },
  u = { ':UndotreeToggle<CR>', 'toggle undotree' },
  v = { ':vsplit<CR>', 'vertical split' },
  V = { ':split<CR>', 'horizontal split' },
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
  z = { ':Tags<CR>', 'search ctags' },
  Z = { ':Helptags<CR>', 'search helptags' },
  ['='] = { '<C-w>=', 'size windows evenly' },
  ['|'] = { ':vsplit<CR>', 'vertical split' },
  ['-'] = { ':split<CR>', 'horizontal split' },
  ['/'] = { ':BLines<CR>', 'search current buffer' },
  ['*'] = { ':BLines <C-r><C-w><CR>', 'search current buffer for word' },
  ['<Leader>'] = { '<c-^>', 'switch between current and last buffer' },
  ['t <Esc>'] = { tc('<C-\\><C-n>'), 'leave terminal mode' },
}

function LeaderMappings.setup()
  vim.g.mapleader = LeaderMappings.config.leader

  require('em.vim').map(LeaderMappings.config.mappings, { prefix = '<Leader>' })
end

function LeaderMappings.reload()
  return require('em.lua').reload('em.config.leader_mappings')
end

return LeaderMappings
