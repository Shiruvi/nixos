{
  pkgs,
  ...
}:
{
  programs.zoxide = {
    enable = true;
    package = pkgs.zoxide;
    enableFishIntegration = true;
  };
  environment.systemPackages = with pkgs; [
    imagemagick
    speedtest
    btop
    brightnessctl
    zip
    unzip
    wl-clipboard
    alsa-utils
    bind
    amdgpu_top
    fd
    ripgrep
    fzf
    lazygit
    superfile
    yt-dlp
  ];
}
