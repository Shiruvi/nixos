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
  environment.systemPackages = [
    inputs.caelestia-shell.packages.${pkgs.system}.with-cli
  ];
}
