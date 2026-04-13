{
  pkgs,
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
    fuzzel
    kitty
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

}
