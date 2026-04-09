{
  pkgs,
  ...
}:
{
  services.power-profiles-daemon = {
    enable = true;
    package = pkgs.power-profiles-daemon;
  };
  programs = {
    steam = {
      enable = true;
    };
    gamemode = {
      enable = true;
      enableRenice = true;
    };
  };

  environment.systemPackages = with pkgs; [
    prismlauncher
    osu-lazer-bin
    retroarch-full
  ];
}
