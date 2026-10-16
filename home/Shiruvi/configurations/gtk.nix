# ┌──────────────────────────────────────────────────────────────────────┐
# │  home/Shiruvi/configurations/gtk.nix — GTK, icons and cursor         │
# │  Author:   Shiruvi                                                   │
# │  Repo:     https://github.com/Shiruvi/nixos                          │
# │  License:  GNU GPL v3.0 or later                                     │
# │                                                                      │
# │  Colours are owned by caelestia-shell: on every wallpaper change it  │
# │  rewrites ~/.config/gtk-{3,4}.0/gtk.css and the dconf keys           │
# │  gtk-theme / icon-theme / color-scheme. This module therefore only   │
# │  installs the theme, icons and cursor, and never creates gtk.css.    │
# └──────────────────────────────────────────────────────────────────────┘
{
  pkgs,
  ...
}:
{
  gtk = {
    enable = true;

    # Same theme Caelestia sets via dconf; its gtk.css recolours it.
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    # Fluent icons (https://github.com/vinceliuice/Fluent-icon-theme).
    # Installs Fluent, Fluent-dark and Fluent-light; Caelestia picks the
    # dark/light one via iconThemeDark/iconThemeLight in caelestia/cli.json.
    iconTheme = {
      name = "Fluent-dark";
      # No `roundedIcons`/`blackPanelIcons` overrides: upstream install.sh
      # (2025-08-21) dropped --round/--black and the build fails with them.
      package = pkgs.fluent-icon-theme;
    };

    # Hide window buttons (minimise / maximise / close) in GTK header bars.
    gtk3.extraConfig.gtk-decoration-layout = "";
    gtk4.extraConfig.gtk-decoration-layout = "";

    # gtk-4.0/gtk.css belongs to Caelestia. With a theme set here Home
    # Manager would create it as a read-only store link, Caelestia would
    # replace it, and the next `home-manager switch` would fail.
    gtk4.theme = null;
  };

  # Only the button layout; gtk-theme, icon-theme and color-scheme in
  # org/gnome/desktop/interface are left to Caelestia.
  dconf.settings."org/gnome/desktop/wm/preferences".button-layout = "";

  # Cursor for GTK, X11/XWayland and Hyprland (also sets XCURSOR_THEME
  # and XCURSOR_SIZE, so no home.sessionVariables are needed).
  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Ice"; # theme name inside the package
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };
}
