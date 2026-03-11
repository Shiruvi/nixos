{
  pkgs,
  pkgs-stable,
  ...
}:
{
  programs.amnezia-vpn.enable = true;
  environment.systemPackages = with pkgs; [
    pkgs-stable.amnezia-vpn
    nftables
    openvpn
  ];
}
