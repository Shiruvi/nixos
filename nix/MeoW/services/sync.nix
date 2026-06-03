{
  services.syncthing = {
    enable = true;
    user = "Shiruvi";
  };
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [
    21027
    22000
  ];
}
