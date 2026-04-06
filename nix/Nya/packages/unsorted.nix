{
  pkgs,
  ...
}:
{
  programs.obs-studio.enable = true;
  environment.systemPackages = with pkgs; [
    keepassxc
    baobab
    pavucontrol
    krita
    kdePackages.kdenlive
    mpv
    blender
    remmina
  ];
}
