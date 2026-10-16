{
  pkgs,
  inputs,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
  };
  qt.enable = true;
  environment.systemPackages = [
    inputs.caelestia-shell.packages.${pkgs.system}.with-cli
    pkgs.papirus-icon-theme
    pkgs.qtengine
    pkgs.darkly
    pkgs.adw-gtk3
  ];
}
