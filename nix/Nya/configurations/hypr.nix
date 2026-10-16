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
    pkgs.qtengine
    pkgs.darkly
  ];
}
