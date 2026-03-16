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
    yarn
    gcc
    gnumake
    rustc
    cargo
    clang-tools
    cmake
    cmake-language-server

    #libraries
    boost
  ];
}
