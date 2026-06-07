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
    migu
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-cjk-sans-static
    noto-fonts-cjk-serif-static
  ];
}
