local M = {}

local packages = {
  'savq/paq-nvim',
  'tjdevries/astronauta.nvim',
  'junegunn/fzf',
  'junegunn/fzf.vim',
  'nvim-lua/popup.nvim',
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope.nvim',
  'sbdchd/neoformat',
  'w0rp/ale',
  'Valloric/ListToggle',
  'Shougo/deoplete.nvim',
  'Shougo/neco-vim',
  'Shougo/neoinclude.vim',
  'Shougo/neco-syntax',
  'deoplete-plugins/deoplete-tag',
  'ludovicchabant/vim-gutentags',
  'tpope/vim-fugitive',
  'junegunn/gv.vim',
  'jreybert/vimagit',
  'justinmk/vim-dirvish',
  'romgrk/searchReplace.vim',
  'tpope/vim-commentary',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  'mulias/vim-caser',
  'rhysd/clever-f.vim',
  'tpope/vim-unimpaired',
  'tpope/vim-eunuch',
  'lambdalisue/suda.vim',
  'junegunn/vim-slash',
  'machakann/vim-highlightedyank',
  'mbbill/undotree',
  'bkad/CamelCaseMotion',
  'junegunn/vim-after-object',
  'kana/vim-textobj-user',
  'kana/vim-textobj-line',
  'kana/vim-textobj-entire',
  'glts/vim-textobj-comment',
  'norcalli/nvim-colorizer.lua',
  'iCyMind/NeoSolarized',
  'rakr/vim-two-firewatch',
  'rakr/vim-colors-rakr',
  'reedes/vim-colors-pencil',
  'owickstrom/vim-colors-paramount'
}

local function paq_init()
  local paq = require('paq-nvim').paq
  for _,p in ipairs(packages) do
    paq {p, opt = true}
  end
end

local function paq_install()
  print("Installing packages with PaqInstall")
  require('paq-nvim').install()
  vim.cmd('helptags ALL')
  print("Packages installed, please restart")
end

local function packadd(package_name, opts)
  local opts = opts or {}
  local silent
  if opts.silent then
    silent = 'silent! '
  else
    silent = ''
  end

  vim.cmd(silent .. 'packadd! ' .. package_name)
end

local paq_pkg = 'paq-nvim'
local paq_path = '/site/pack/paqs/start/'
local paq_repo = 'https://github.com/savq/paq-nvim.git'

local function download_paq()
  local directory = vim.fn.stdpath('data') .. paq_path

  vim.fn.mkdir(directory, 'p')

  local out = vim.fn.system(
    string.format('git clone %s %s%s', paq_repo, directory, paq_pkg)
  )

  print(out)

  local clone_success = vim.v.shell_error == 0

  if clone_success then
    print(string.format("Downloaded paq-nvim to '%s%s'", directory, paq_pkg))
  else
    print("Error downloading paq-nvim")
  end
end

local function confirm_download_paq()
  local input = vim.fn.confirm('Download Paq and install packages?', '&Yes\n&No', 2)
  return input == 1
end

function M.setup()
  packadd('paq-nvim', {silent = true})

  if not pcall(require, 'paq-nvim') then
    if confirm_download_paq() then
      download_paq()
      packadd('paq-nvim')
      paq_init()
      paq_install()
    else
      print('Unable to load packages, config disabled')
    end

    return false
  end

  paq_init()
  return true
end

M.load = packadd

return M
