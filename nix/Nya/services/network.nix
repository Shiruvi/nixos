{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    linux-wifi-hotspot
  ];
  networking.hostName = "Nya";
  networking.networkmanager.enable = true;
}
