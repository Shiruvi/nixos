{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    linux-wifi-hotspot
    inetutils
    openssl
  ];
  networking.hostName = "Nya";
  networking.networkmanager.enable = true;
}
