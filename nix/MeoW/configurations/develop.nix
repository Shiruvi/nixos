{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    nix-web
    nix-btm
    nix-health
    nix-visualize
    git
    grex
  ];
}
