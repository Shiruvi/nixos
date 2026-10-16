# ┌──────────────────────────────────────────────────────────────────────┐
# │  home/Shiruvi/configurations/icons.nix — missing app icons here      │
# │  Author:   Shiruvi                                                   │
# │  Repo:     https://github.com/Shiruvi/nixos                          │
# │  License:  GNU GPL v3.0 or later                                     │
# │                                                                      │
# │  Colours are owned by caelestia-shell: on every wallpaper change it  │
# │  rewrites ~/.config/gtk-{3,4}.0/gtk.css and the dconf keys           │
# │  gtk-theme / icon-theme / color-scheme. This module therefore only   │
# │  installs the theme, icons and cursor, and never creates gtk.css.    │
# └──────────────────────────────────────────────────────────────────────┘
# TODO: make unike description for this file
{
  xdg.desktopEntries.tgwsproxy = {
    name = "TgWsProxy";
    exec = "steam-run /home/Shiruvi/Downloads/TgWsProxy_linux_amd64";
    icon = "accessories-calculator"; # any name from Fluent, or a full path to an image
  };
}
