{ pkgs, ... }:
{
  imports = [
    ./Nya/modules.nix
    ./users/Shiruvi.nix
    ./universal/modules.nix
  ];
  environment.systemPackages = with pkgs; [
    home-manager
    nh
  ];
  nixpkgs.config.allowUnfree = true;
  networking.hostName = "Nya";
  time.timeZone = "Europe/Moscow";
}
