{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    vim
    nix-tree
    pciutils
  ];
}
