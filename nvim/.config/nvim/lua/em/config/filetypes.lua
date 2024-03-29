--[[----------------------------------------------------------------------------
Filetypes

Configs for filetype specific settings. While these settings are defined here,
they are sourced via `after/ftplugin/` when an appropriate buffer is opened.
------------------------------------------------------------------------------]]

local Filetypes = {}

Filetypes.config = {
  dirvish = function()
    -- Use K for zoomies not file info
    vim.api.nvim_buf_set_keymap(0, '', '<Leader>k', '<Plug>(dirvish_K)', {})
    vim.api.nvim_buf_set_keymap(0, '', 'K', 'kkk', { noremap = true })
  end,

  elm = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,

  gitcommit = function()
    vim.cmd('setlocal spell')
    vim.opt_local.textwidth = 72
    vim.opt_local.colorcolumn = { 73 }
  end,

  help = function()
    vim.api.nvim_buf_set_keymap(0, '', 'K', 'kkk', { noremap = true })
  end,

  magit = function()
    local vimagit_group = vim.api.nvim_create_augroup('vimagit', {})

    vim.api.nvim_create_autocmd('User', {
      pattern = 'VimagitEnterCommit',
      command = 'setlocal spell | setlocal textwidth=72 | setlocal colorcolumn=73',
      group = vimagit_group,
    })
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VimagitLeaveCommit',
      command = 'setlocal nospell | setlocal textwidth=0 | setlocal colorcolumn=',
      group = vimagit_group,
    })
  end,

  text = function()
    vim.cmd('setlocal spell')
    vim.opt_local.textwidth = 80
  end,

  python = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 8
    vim.opt_local.softtabstop = 8
  end,
}

function Filetypes.setup(filetype)
  local ft = filetype or vim.bo.ft

  Filetypes.config[ft]()
end

function Filetypes.reload()
  return require('em.lua').reload('em.config.filetypes')
end

return Filetypes
