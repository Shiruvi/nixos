{
  pkgs,
  ...
}:
{
  programs.dconf.profiles.user = {
    databases = [
      {
        settings = {
          "org/gnome/desktop/wm/preferences" = {
            button-layout = "";
          };
        };
      }
    ];
  };
  # fonts
  fonts.packages = with pkgs; [
    # Nerd fonts
    nerd-fonts.jetbrains-mono
    # Office fonts
    corefonts
    # Other fonts
    adwaita-fonts
  ];
  environment.systemPackages = with pkgs; [
    # gui customization app
    nwg-look
    # cursors
    bibata-cursors
    # themes
    tokyonight-gtk-theme
    # icons
    adwaita-icon-theme
  ];
}
