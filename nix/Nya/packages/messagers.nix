{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    element-desktop
    telegram-desktop
    vesktop
  ];
}
