--[[----------------------------------------------------------------------------
Autocommands

Execute commands tied to vim events. Organized into "features" where each
feature can be toggled on and off through key bindings or a command. Each
feature is always available, but the `start_enabled` flag determines if it
defaults to being on or off per buffer or session.
------------------------------------------------------------------------------]]

local Autocommands = {}

Autocommands.config = {
  -- Format on write
  -- Uses the Neoformat plugin and a custom format function to strip trailing
  -- whitespace. Toggle per-buffer with `cof`, `<Leader>of`, or
  -- `:ToggleFormat`. Run manually with `:Format`.
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
}

function Autocommands.setup()
  for auto_name, auto_config in pairs(Autocommands.config) do
    vim.g[auto_name .. '_start_enabled'] = auto_config.start_enabled

    require('em.vim').augroup(auto_name, auto_config)
  end
end

function Autocommands.reload()
  return require('em.lua').reload('em.config.autocommands')
end

return Autocommands
