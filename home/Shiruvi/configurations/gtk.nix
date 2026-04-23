{
  pkgs,
  ...
}:
{
  gtk = {
    gtk4.theme = null;
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
      icon-theme = "Adwaita";
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
