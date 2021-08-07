--[[----------------------------------------------------------------------------
Filetypes

Configs for filetype specific settings. While these settings are defined here,
they are sourced via `after/ftplugin/` when an appropriate buffer is opened.
------------------------------------------------------------------------------]]

local Filetypes = {}

Filetypes.config = {}

function Filetypes.config.dirvish()
  -- Use K for zoomies not file info
  vim.api.nvim_buf_set_keymap(0, '', '<Leader>k', '<Plug>(dirvish_K)', {})
  vim.api.nvim_buf_set_keymap(0, '', 'K', 'kkk', { noremap = true })
end

function Filetypes.config.elm()
  vim.opt_local.tabstop = 4
  vim.opt_local.shiftwidth = 4
end

function Filetypes.config.gitcommit()
  vim.cmd('setlocal spell')
  vim.opt_local.textwidth = 72
  vim.opt_local.colorcolumn = { 73 }
end

function Filetypes.config.help()
  vim.api.nvim_buf_set_keymap(0, '', 'K', 'kkk', { noremap = true })
end

function Filetypes.config.magit()
  require('em.vim').augroup('vimagit', {
    {
      'User VimagitEnterCommit',
      'setlocal spell | setlocal textwidth=72 | setlocal colorcolumn=73',
    },
    {
      'User VimagitLeaveCommit',
      'setlocal nospell | setlocal textwidth=0 | setlocal colorcolumn=',
    },
  })
end

function Filetypes.config.text()
  vim.cmd('setlocal spell')
  vim.opt_local.textwidth = 80
end

function Filetypes.config.python()
  vim.opt_local.expandtab = false
  vim.opt_local.tabstop = 8
  vim.opt_local.softtabstop = 8
end

function Filetypes.setup(ft)
  Filetypes.config[ft]()
end

function Filetypes.reload()
  return require('em.lua').reload('em.config.filetypes')
end

return Filetypes
