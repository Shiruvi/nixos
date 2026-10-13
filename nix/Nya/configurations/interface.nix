{ pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    # macOS-стиль
    whitesur-kde
    whitesur-gtk-theme
    whitesur-icon-theme
    whitesur-cursors
    # Windows-стиль
    fluent-gtk-theme
    fluent-icon-theme
    # утилиты
    konsave # сохранение/применение профилей Plasma
    (writeShellScriptBin "style-switch" (builtins.readFile ../../../scripts/style-switch.sh))
  ];

  fonts.packages = with pkgs; [
    inter
    noto-fonts
  ]; # Inter близок к SF Pro / Segoe
}
