{
  pkgs,
  ...
}:
{
  services.tailscale.enable = true;
  environment.systemPackages = with pkgs; [
    remmina
    qbittorrent
  ];
}
