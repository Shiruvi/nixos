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
    nirius
    mako
    awww
    kitty
  ];

}
