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
    rustc
    cargo
    clang-tools
  ];
}
