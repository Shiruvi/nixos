{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    fastfetch
    lsd
    eza
    bat
    cmatrix
    kittysay
  ];
}
