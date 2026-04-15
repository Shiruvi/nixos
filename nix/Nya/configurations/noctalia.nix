{
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    #ofor screen tools plugin
  ];
}
