{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    fastfetch
    btop
    brightnessctl
    zip
    unzip
    wl-clipboard
    eza
    bat
  ];
}
