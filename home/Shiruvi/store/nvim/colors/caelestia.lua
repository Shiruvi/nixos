-- ┌──────────────────────────────────────────────────────────────────────┐
-- │  nvim/colors/caelestia.lua — colorscheme that follows Caelestia      │
-- │  Author:   Shiruvi                                                   │
-- │  Repo:     https://github.com/Shiruvi/nixos                          │
-- │  License:  GNU GPL v3.0 or later                                     │
-- │                                                                      │
-- │  Reads the palette caelestia-cli generated from the wallpaper        │
-- │  (see caelestia/templates/nvim.lua) and applies it with mini.base16. │
-- │  Falls back to tokyonight-night until the first wallpaper change.    │
-- └──────────────────────────────────────────────────────────────────────┘
local state = os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")
local file = state .. "/caelestia/theme/nvim.lua"

local ok, palette = pcall(dofile, file)
local has_base16, base16 = pcall(require, "mini.base16")

if not (ok and type(palette) == "table" and has_base16) then
  vim.cmd.colorscheme("tokyonight-night")
  return
end

vim.cmd("highlight clear")
base16.setup({ palette = palette, use_cterm = true })
vim.g.colors_name = "caelestia"
