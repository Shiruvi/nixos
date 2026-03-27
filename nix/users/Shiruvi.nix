{
  pkgs,
  ...
}:
{
  users.users.Shiruvi = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "audio"
      "wheel"
      "input"
      "networkmanager"
      "storage"
      "disk"
      "uinput"
      "wireshark"
    ];
  };
  nix.trustedUsers = [ "Shiruvi" ];
}
