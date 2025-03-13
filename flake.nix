{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
    wallpaperPath = ./fujisan.png;
  in {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {inherit inputs system wallpaperPath;};
        modules = [
          ./hosts/default/configuration.nix
          inputs.disko.nixosModules.default
          ./hosts/default/disk-config.nix
          ./modules/nixos
        ];
      };
      desktop = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {inherit inputs system wallpaperPath;};
        modules = [
          ./hosts/desktop/configuration.nix
          inputs.disko.nixosModules.default
          ./hosts/desktop/disk-config.nix
          ./modules/nixos
        ];
      };
    };
    nixosModules.neovim = import ./modules/exposed/nixvim.nix;
    homeManagerModules.default = ./modules/home-manager;
  };
}
