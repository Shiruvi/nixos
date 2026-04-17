{
  pkgs,
  ...
}:
{
  gtk = {
    gtk4.theme = null;
    enable = true;
    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.adwaita-icon-theme;
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Tokyonight-Dark";
      icon-theme = "Dracula";
    };
  };
  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice"; # Твое точное имя темы
    XCURSOR_SIZE = "24";
  };
  home.pointerCursor = {
    name = "Bibata-Modern-Ice"; # точное имя темы внутри пакета
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true; # автоматически настроит GTK3
  };
  home.packages = with pkgs; [
    tokyonight-gtk-theme
    adwaita-icon-theme
  ];
}
