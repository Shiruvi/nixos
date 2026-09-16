{
  pkgs,
  pkgs-stable,
  ...
}:
{
  programs.niri = {
    enable = true;
    useNautilus = true;
  };
  environment.systemPackages = with pkgs; [
    pkgs-stable.xwayland-satellite
    nautilus
    fuzzel
    mako
    awww
    kitty
  ];

}
