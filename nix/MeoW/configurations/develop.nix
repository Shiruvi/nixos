{
  pkgs,
  ...
}:
{
  system.environmentPacages with pkgs; [
    nix-locate
  ];
}
