{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    fastfetch
    lsd
    bat
    cmatrix
    kittysay

  ];
}
