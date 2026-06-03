{
  services.syncthing = {
    enable = true;
    user = "Shiruvi";
    dataDir = "/home/Shiruvi/Sync";
    configDir = "/home/Shiruvi/.config/syncthing";
  };
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [
    21027
    22000
  ];
}
