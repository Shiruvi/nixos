{
  pkgs,
  ...
}:
{
  programs.obs-studio.enable = true;
  environment.systemPackages = with pkgs; [
    git
    telegram-desktop
    fluffychat
    vesktop
    keepassxc
    baobab
    amdgpu_top
    pavucontrol
    alsa-utils
    bind
    yazi
  ];
}
