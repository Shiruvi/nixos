{ pkgs, ... }:
{
  imports = [
    ./MeoW/modules.nix
    ./users/Shiruvi.nix
    ./universal/modules.nix
  ];
  environment.systemPackages = with pkgs; [
    home-manager
    nh
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "MeoW";
  time.timeZone = "Europe/Moscow";
}
