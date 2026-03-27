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
    gimp
    kdePackages.kdenlive
    remmina
  ];
}
