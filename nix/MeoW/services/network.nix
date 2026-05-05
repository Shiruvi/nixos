{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    inetutils
    openssl
  ];
  networking.hostName = "MeoW";
  networking.networkmanager.enable = true;
}
