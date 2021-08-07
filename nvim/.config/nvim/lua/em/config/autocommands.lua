--[[----------------------------------------------------------------------------
Autocommands

Execute commands tied to vim events. Organized into "features" where each
feature can have namespaced `vim.g` flags. We use this to toggle some features
on and off through key bindings or a command. Each such feature is always
available, but the `start_enabled` flag determines if it defaults to being on
or off per buffer or session.
------------------------------------------------------------------------------]]

local Autocommands = {}

Autocommands.config = {
  -- Format on write
  -- Format current buffer via LSP. Toggle per-buffer with `cof`, `<Leader>of`,
  -- or `:ToggleFormat`. Run manually with `:Format`.
  format_on_write = {
    'BufWritePre * lua require("em.fn").format_buffer_if_enabled()',
    start_enabled = true,
  },
  -- Window resize
  -- Uses the Focus plugin to ensure the active buffer is at least 80 columns
  -- wide, and then balances all other windows to be equal widths. Toggle
  -- per-session with `co=`, `<Leader>o=`, or `:ToggleWindowResize`.
  window_resize = {
    'VimEnter * lua require("em.fn").sync_window_resize_settings()',
    'VimResized,WinEnter * lua require("em.fn").window_resize_if_enabled()',
    start_enabled = true,
  },
  -- Highlight On Yank
  -- Briefly highlight text that was just yanked. Toggle per-buffer with `coy`,
  -- `<Leader>oy`, or `:ToggleHighlightYank`.
  highlight_on_yank = {
    'TextYankPost * silent! lua require("em.fn").highlight_yank_if_enabled()',
    start_enabled = true,
  },
  -- Override Colorscheme
  -- Set some general highlightling rules after a colorscheme is applied to
  -- enforce preferences that an otherwise good colorscheme might not follow.
  override_colorscheme = {
    'ColorScheme * lua require("em.config.ui").config.highlight_overrides()',
  },
}

function Autocommands.setup()
  for auto_name, auto_config in pairs(Autocommands.config) do
    for setting_name, setting_val in require('em.lua').kpairs(auto_config) do
      vim.g[auto_name .. '_' .. setting_name] = setting_val
    end

    require('em.vim').augroup(auto_name, require('em.lua').itable(auto_config))
  end
end

function Autocommands.reload()
  return require('em.lua').reload('em.config.autocommands')
end

return Autocommands
