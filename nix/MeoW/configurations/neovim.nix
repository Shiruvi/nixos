{
  pkgs,
  ...
}:
{
  # neovim enable
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  # dependences
  environment.systemPackages = with pkgs; [
    nodejs
    python3
    rustc
    clang
    nil
    yarn
    gcc
    gnumake
    rustc
    cargo
    clang-tools
    cmake-language-server
  ];
}
