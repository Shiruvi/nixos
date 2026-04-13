{
  pkgs,
  inputs,
  ...
}:
{
  programs.niri = {
    enable = true;
    useNautilus = true;
  };
  environment.systemPackages = with pkgs; [
    xwayland-satellite
    nautilus
    kitty
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

}
