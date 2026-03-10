{
  pkgs,
  ...
}:
{
  programs.amnezia-vpn = {
    enable = true;
    package = pkgs.amnezia-vpn;
  };
  environment.systemPackages = with pkgs; [
    nftables
    openvpn
  ];
}
