{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    nix-web
    nix-btm
    git
    grex
  ];
}
