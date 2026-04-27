{
  pkgs,
  pkgs-stable,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    element-desktop
    pkgs-stable.telegram-desktop
    vesktop
  ];
}
