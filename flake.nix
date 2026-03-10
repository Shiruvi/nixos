{
  description = "SysConf2";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    simple-wallpaper-engine.url = "github:Maxnights/simple-linux-wallpaperengine-gui";
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      simple-wallpaper-engine,
      ...
    }:
    {
      nixosConfigurations = {
        Nya = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/Nya.nix
          ];
        };
        MeoW = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/MeoW.nix
          ];
        };
      };
      homeConfigurations.Shiruvi = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ./home/Shiruvi/home.nix
          simple-wallpaper-engine.homeManagerModules.default
        ];
      };
    };
}
