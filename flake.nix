{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim-1gmar = {
      url = "github:1gmar/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    colors = {
      background = "#fdf6e3";
      backgroundHigh = "#eee8d5";
      blue = "#268bd2";
      cyan = "#2aa198";
      foreground0 = "#839496";
      foregroundEmph = "#586e75";
      green = "#859900";
      magenta = "#d33682";
      orange = "#cb4b16";
      red = "#dc322f";
      secondaryContent = "#93a1a1";
      text = "#657b83";
      violet = "#6c71c4";
      yellow = "#b58900";
    };
    shell-theme = ./modules/home-manager/nushell/solarized-light.nu;
    sys-diff = ./modules/home-manager/nushell/system-diff.nu;
    system = "x86_64-linux";
    userName = "igmar";
    wallpaperPath = ./anime-sky.png;
  in {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs system userName wallpaperPath;};
        modules = [
          ./hosts/default/configuration.nix
          inputs.disko.nixosModules.default
          ./hosts/default/disk-config.nix
          ./modules/nixos
        ];
      };
      desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit colors inputs shell-theme sys-diff system userName wallpaperPath;};
        modules = [
          inputs.disko.nixosModules.default
          ./hosts/desktop/disk-config.nix
          ./hosts/desktop/configuration.nix
          ./hosts/desktop/home-configuration.nix
          ./modules/nixos
        ];
      };
    };
    homeManagerModules.default = ./modules/home-manager;
  };
}
