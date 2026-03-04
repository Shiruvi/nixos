{
  pkgs,
  config,
  ...
}:
{
  programs.dconf.profiles.user = {
    databases = [{
      settings = {
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "";
        };
      };
    }];
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
    adw-gtk3
    # icons
    adwaita-icon-theme
  ];
}
