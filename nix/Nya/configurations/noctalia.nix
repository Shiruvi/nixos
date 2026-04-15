{
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    #ofor screen tools plugin
    grim
    slurp
    wl-clipboard
    tesseract
    imagemagick
    zbar
    curl
    wl-screenrec
    ffmpeg
    gifski
    jq
  ];
}
