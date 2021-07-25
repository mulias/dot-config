--[[----------------------------------------------------------------------------
Bootstrap

Make sure we're all set to run the rest of `init.lua`. Check that the package
manager module is available, and if it isn't start an interactive flow to
download and setup packages. This should help with the initial awkward step of
setting up nvim in a new environment.
------------------------------------------------------------------------------]]

local Bootstrap = {}

local plugin_directory = require('em.lua').join_paths(
  vim.fn.stdpath('data'),
  'site/pack/packer'
)
local packer_directory = require('em.lua').join_paths(
  plugin_directory,
  'start',
  'packer.nvim'
)
local compile_path = require('em.lua').join_paths(
  vim.fn.stdpath('config'),
  'lua',
  'em',
  'packer_compiled_packages.lua'
)

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
  require('em.vim').augroup('init_bootstrap', {
    { 'VimEnter', '*', 'lua require("em.config.packages").manage().sync()' },
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

function Bootstrap.hard_reset()
  local input = vim.fn.confirm(
    'Delete installed plugins and reset?',
    '&Yes\n&No',
    2
  )
  if input ~= 1 then
    print('Reset aborted')
    return
  end

  local out = vim.fn.system({
    'rm',
    '-rf',
    plugin_directory,
    '&',
    'rm',
    compile_path,
  })
  print(out)
  local reset_success = vim.v.shell_error == 0
  if reset_success then
    print('Reset complete, restart to re-run setup')
  else
    error('Error completing reset')
  end
end

function Bootstrap.reload()
  return require('em.lua').reload('em.bootstrap')
end

return Bootstrap
