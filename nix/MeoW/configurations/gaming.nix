{
  pkgs,
  ...
}:
{
  services.power-profiles-daemon = {
    enable = true;
    package = pkgs.power-profiles-daemon;
  };
  programs.steam = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    prismlauncher
    osu-lazer-bin
  ];
}
