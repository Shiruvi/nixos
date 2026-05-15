{
  pkgs,
  ...
}:
{
  hardware.wooting.enable = true;
  environment.systemPackages = with pkgs; [
    wooting-udev-rules
    wootility
  ];
}
