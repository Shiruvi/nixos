{
  pkgs,
  ...
}:
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Dracula";
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
}
