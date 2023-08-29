--[[----------------------------------------------------------------------------
Bootstrap

Make sure we're all set to run the rest of `init.lua`. Check that the plugin
manager module is available, and if it isn't start an interactive flow to
download and setup plugins. This should help with the initial awkward step of
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
local packer_repo = 'https://github.com/wbthomason/packer.nvim'

local function is_packer_missing()
  return not pcall(require, 'packer')
end

local function confirm_download_packer()
  local input = vim.fn.confirm(
    'Download Packer and install plugins?',
    '&Yes\n&No',
    2
  )
  if input ~= 1 then
    vim.notify('Unable to install plugins without Packer', vim.log.levels.WARN)
  end
end

local function download_packer()
  vim.fn.mkdir(plugin_directory, 'p')

  local out = vim.fn.system({ 'git', 'clone', packer_repo, packer_directory })

  vim.notify(out, vim.log.levels.INFO)

  local clone_success = vim.v.shell_error == 0

  if clone_success then
    vim.notify('Downloaded Packer to ' .. packer_directory, vim.log.levels.INFO)
  else
    vim.notify('Error downloading Packer', vim.log.levels.ERROR)
  end
end

function Bootstrap.confirm_restart()
  local input = vim.fn.confirm('Restart to complete setup?', '&Yes\n&No', 1)
  if input == 1 then
    vim.cmd('qa!')
  end
end

local function install_plugins_on_vim_enter()
  vim.cmd('packadd packer.nvim')

  local bootstrap_group = vim.api.nvim_create_augroup('bootstrap', {})

  vim.api.nvim_create_autocmd('VimEnter', {
    pattern = '*',
    once = true,
    callback = function()
      require('em.config.plugins').manage().sync()
    end,
    group = bootstrap_group,
  })

  vim.api.nvim_create_augroup('User', {
    pattern = 'PackerComplete',
    once = true,
    callback = require('em.bootstrap').confirm_restart,
    group = bootstrap_group,
  })
end

function Bootstrap.first_time_setup()
  if is_packer_missing() then
    confirm_download_packer()
    download_packer()
    install_plugins_on_vim_enter()
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
    vim.notify('Reset aborted', vim.log.levels.INFO)
    return
  end

  local out = vim.fn.system(
    string.format(
      'rm -rf %s & rm %s',
      plugin_directory,
      require('em.config.plugins').config.packer.compile_path
    )
  )
  vim.notify(out, vim.log.levels.INFO)
  local reset_success = vim.v.shell_error == 0
  if reset_success then
    vim.notify('Reset complete, restart to re-run setup', vim.log.levels.INFO)
  else
    vim.notify('Error completing reset', vim.log.levels.ERROR)
  end
end

function Bootstrap.reload()
  return require('em.lua').reload('em.bootstrap')
end

return Bootstrap
