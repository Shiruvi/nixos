{
  pkgs,
  inputs,
  ...
}:
let
  system = "x86_64-linux";
in
{
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland = true;
  };
  environment.systemPackages = [
    inputs.caelestia-shell.packages.${system}.with-cli
  ];
}
