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
    losslesscut-bin
    blender
    onlyoffice-desktopeditors
    obsidian
    helvum
    anki-bin
  ];
}
