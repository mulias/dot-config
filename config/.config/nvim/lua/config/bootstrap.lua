--[[----------------------------------------------------------------------------
Bootstrap

Make sure we're all set to run the rest of `init.lua`. Check that the package
manager module is available, and if it isn't start an interactive flow to
download and setup packages. This should help with the initial awkward step of
setting up nvim in a new environment.
------------------------------------------------------------------------------]]

local Bootstrap = {}

local packer_pkg = 'packer.nvim'
local packer_path = '/site/pack/packer/start/'
local packer_repo = 'https://github.com/wbthomason/packer.nvim'

local function is_packer_missing()
  return not pcall(require, 'packer')
end

local function confirm_download_packer()
  local input = vim.fn.confirm(
    'Download Packer and install packages?',
    '&Yes\n&No',
    2
  )
  if input ~= 1 then
    error('Unable to install packages without package manager')
  end
end

local function download_packer()
  local plugin_directory = vim.fn.stdpath('data') .. packer_path
  local packer_directory = plugin_directory .. packer_pkg

  vim.fn.mkdir(plugin_directory, 'p')

  local out = vim.fn.system({ 'git', 'clone', packer_repo, packer_directory })

  print(out)

  local clone_success = vim.v.shell_error == 0

  if clone_success then
    print('Downloaded Packer to ' .. packer_directory)
  else
    error('Error downloading Packer')
  end
end

local function install_packages_on_vim_enter()
  print('Install packages then restart to complete setup')
  vim.cmd('packadd packer.nvim')
  require('util.vim').augroup('init_bootstrap', {
    { 'VimEnter', '*', 'lua require("config.packages").manage().sync()' },
  })
end

function Bootstrap.first_time_setup()
  if is_packer_missing() then
    confirm_download_packer()
    download_packer()
    install_packages_on_vim_enter()
    return true
  else
    return false
  end
end

function Bootstrap.reload()
  return require('util.lua').reload('config.bootstrap')
end

return Bootstrap
