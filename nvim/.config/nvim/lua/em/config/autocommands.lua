--[[----------------------------------------------------------------------------
Autocommands

Execute commands tied to vim events. Some autocommands have a `start_enabled`
flag which determines if the command defaults to being on or off per buffer or
session.
------------------------------------------------------------------------------]]

local Autocommands = {}

Autocommands.config = {
  -- Start with current directory
  -- When vim first starts display the current directory instead of an empty
  -- buffer.
  show_dir_on_start = {
    event = 'VimEnter',
    callback = require('em.fn').open_file_manager_if_default_start,
  },
  -- Format on write
  -- Format current buffer via LSP. Toggle per-buffer with `cof`, `<Leader>of`,
  -- or `:ToggleFormat`. Run manually with `:Format`.
  format_on_write = {
    event = 'BufWritePre',
    callback = require('em.fn').format_buffer_if_enabled,
    start_enabled = true,
  },
  -- Window resize
  -- Ensure that the active buffer is at least 85 columns wide, and then
  -- balances all other windows to be equal widths. Toggle per-session with
  -- `co=`, `<Leader>o=`, or `:ToggleWindowResize`. We use `schedule` to
  -- briefly defer running the resize. This allows new buffers to set their
  -- filetype, which we may use to make certain layout exceptions.
  window_resize = {
    event = 'WinEnter',
    callback = function()
      vim.schedule(require('em.fn').window_resize_if_enabled)
    end,
    start_enabled = true,
  },
  -- Highlight On Yank
  -- Briefly highlight text that was just yanked. Toggle per-buffer with `coy`,
  -- `<Leader>oy`, or `:ToggleHighlightYank`.
  highlight_on_yank = {
    event = 'TextYankPost',
    callback = require('em.fn').highlight_yank_if_enabled,
    start_enabled = true,
  },
  -- Override Colorscheme
  -- Set some general highlightling rules after a colorscheme is applied to
  -- enforce preferences that an otherwise good colorscheme might not follow.
  override_colorscheme = {
    event = 'ColorScheme',
    callback = require('em.config.ui').config.highlight_overrides,
  },
  -- Populate location list with diagnostics
  location_list_diagnostics = {
    event = 'DiagnosticChanged',
    callback = function()
      vim.diagnostic.setloclist({ open = false })
    end,
  },
  -- Roc filetype detection
  roc_filetype = {
    event = {'BufRead', 'BufNewFile'},
    pattern = '*.roc',
    callback = function()
      vim.opt_local.filetype = 'roc'
    end,
  },
}

function Autocommands.setup()
  for auto_name, auto_config in pairs(Autocommands.config) do
    vim.api.nvim_create_autocmd(auto_config.event, {
      pattern = auto_config.pattern or '*',
      callback = auto_config.callback,
      group = vim.api.nvim_create_augroup(auto_name, {}),
    })

    if auto_config.start_enabled ~= nil then
      vim.g[auto_name .. '_' .. 'start_enabled'] = auto_config.start_enabled
    end
  end
end

function Autocommands.reload()
  return require('em.lua').reload('em.config.autocommands')
end

return Autocommands
