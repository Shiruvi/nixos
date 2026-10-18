{
  pkgs,
  ...
}:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      settings.addons.xcb.globalSection = {
        "Allow Overriding System XKB Settings" = "False";
        AlwaysSetToGroupLayout = "False";
      };
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
      ];
    };
  };
  environment.variables = {
    XMODIFIERS = "@im=fcitx";
  };
  # Keep Hyprland's us,ru layouts in XWayland apps (Steam, OnlyOffice):
  # fcitx5's X11 module otherwise forces its own group layout there.
}
