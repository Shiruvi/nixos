-- ┌──────────────────────────────────────────────────────────────────────┐
-- │  caelestia/templates/nvim.lua — Caelestia user template for Neovim   │
-- │  Author:   Shiruvi                                                   │
-- │  Repo:     https://github.com/Shiruvi/nixos                          │
-- │  License:  GNU GPL v3.0 or later                                     │
-- │                                                                      │
-- │  caelestia-cli fills the {{ name.hex }} fields on every wallpaper /  │
-- │  scheme change and writes the result to                              │
-- │  ~/.local/state/caelestia/theme/nvim.lua (mode: {{ mode }}).         │
-- │  Neovim loads it in colors/caelestia.lua as a base16 palette.        │
-- └──────────────────────────────────────────────────────────────────────┘
return {
  -- UI shades: background -> foreground
  base00 = "#{{ background.hex }}",            -- default background
  base01 = "#{{ surfaceContainer.hex }}",      -- status line, popups
  base02 = "#{{ surfaceContainerHighest.hex }}", -- selection, cursor line
  base03 = "#{{ outline.hex }}",               -- comments, invisibles
  base04 = "#{{ onSurfaceVariant.hex }}",      -- dark foreground (status bars)
  base05 = "#{{ onSurface.hex }}",             -- default foreground
  base06 = "#{{ onBackground.hex }}",          -- light foreground
  base07 = "#{{ inverseSurface.hex }}",        -- lightest foreground
  -- Accents: terminal colours, generated from the wallpaper
  base08 = "#{{ term1.hex }}",                 -- red: variables, errors
  base09 = "#{{ term9.hex }}",                 -- bright red: numbers, constants
  base0A = "#{{ term3.hex }}",                 -- yellow: types, search
  base0B = "#{{ term2.hex }}",                 -- green: strings
  base0C = "#{{ term6.hex }}",                 -- cyan: regex, escapes
  base0D = "#{{ primary.hex }}",               -- primary: functions
  base0E = "#{{ tertiary.hex }}",              -- tertiary: keywords
  base0F = "#{{ secondary.hex }}",             -- secondary: delimiters
}
