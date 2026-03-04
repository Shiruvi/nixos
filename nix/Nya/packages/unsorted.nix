{
  pkgs,
  ...
}:
{
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




    clang-tools
    nil
  ];
}
