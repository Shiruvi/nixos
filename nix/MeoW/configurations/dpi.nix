{
  pkgs,
  pkgs-stable,
  ...
}:
{
  programs.amnezia-vpn = {
    enable = true;
    package = pkgs-stable.amnezia-vpn;
  };
  environment.systemPackages = with pkgs; [
    nftables
    openvpn
    openssl
  ];
}
