{ pkgs, config, ... }:
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
  nixpkgs.config.allowUnfree = true;
  programs.steam.enable = true;
  networking.hostName = "MeoW";
  time.timeZone = "Europe/Moscow";
}
