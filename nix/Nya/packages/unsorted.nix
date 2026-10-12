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
    openscad
    onlyoffice-desktopeditors
    typst
    obsidian
    helvum
    qalculate-gtk
    anki-bin
  ];
}
