{
  pkgs,
  ...
}:
{
  programs.obs-studio.enable = true;
  environment.systemPackages = with pkgs; [
    git
    keepassxc
    baobab
    amdgpu_top
    pavucontrol
    alsa-utils
    bind
    gimp
    kdePackages.kdenlive
    remmina
  ];
}
