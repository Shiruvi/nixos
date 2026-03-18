{
  programs.fish = {
    enable = true;
    shellAliases = {
      shellinstall = "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && fisher install IlanCosman/tide@v6";
    };
  };
}
