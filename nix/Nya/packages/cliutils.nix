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
