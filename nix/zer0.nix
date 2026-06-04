{ pkgs, ... }:
{
  imports = [
    ./zer0/modules.nix
    ./users/zero
    ./universal/modules.nix
  ];
  environment.systemPackages = with pkgs; [
    home-manager
    nh
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "zer0";
  time.timeZone = "Europe/Moscow";
}
