{
  pkgs,
  inputs,
  ...
}:
  home.packages = [
    inputs.linux-wallpaper-engine.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
