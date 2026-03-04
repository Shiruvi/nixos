{
  pkgs,
  ...
}:
{
  programs.fish.enable = true;
  programs.fish.plugins = [
      # Tide - современная тема
      {
        name = "tide";
        src = pkgs.fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "v6.0.1";  # Используй последнюю версию
          sha256 = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX="; # Нужно будет заменить
        };
      }
      ];
}
