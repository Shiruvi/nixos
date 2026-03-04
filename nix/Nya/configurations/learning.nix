{
  pkgs,
  ...
}:
{
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  environment.systemPackages = with pkgs; [
    inetutils
    openssl
  ];
}
