-- ┌──────────────────────────────────────────────────────────────────────┐
-- │  nvim/lua/plugins/caelestia.lua — live Caelestia colours in Neovim   │
-- │  Author:   Shiruvi                                                   │
-- │  Repo:     https://github.com/Shiruvi/nixos                          │
-- │  License:  GNU GPL v3.0 or later                                     │
-- │                                                                      │
-- │  Installs mini.base16 (used by colors/caelestia.lua) and reloads the │
-- │  colorscheme in every running Neovim when Caelestia rewrites the     │
-- │  palette, so the editor recolours together with the wallpaper.       │
-- └──────────────────────────────────────────────────────────────────────┘

---@type LazySpec
return {
  {
    "nvim-mini/mini.base16",
    lazy = false, -- needed by the colorscheme at startup
    priority = 1000, -- load before other plugins
    config = function()
      local state = os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")
      local dir = state .. "/caelestia/theme"
      if vim.fn.isdirectory(dir) == 0 then return end

      -- caelestia-cli replaces the file atomically (write + rename), so
      -- watch the directory rather than the file itself.
      local watcher = vim.uv.new_fs_event()
      watcher:start(dir, {}, function(_, filename)
        if filename ~= "nvim.lua" then return end
        vim.schedule(function()
          if vim.g.colors_name == "caelestia" then vim.cmd.colorscheme("caelestia") end
        end)
      end)
    end,
  },
}
