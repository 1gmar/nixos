{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-25.11";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim-1gmar = {
      url = "github:1gmar/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    color-themes.url = "github:1gmar/color-themes";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      colors = inputs.color-themes.solarized.light;
      colors-dark = inputs.color-themes.solarized.dark;
      pkgs = import nixpkgs { inherit system; };
      shell-theme = ./modules/home-manager/nushell/solarized-light.nu;
      system = "x86_64-linux";
      userName = "igmar";
      wallpaperPath = ./anime-sky.png;
    in
    {
      devShells.${system}.desktop = pkgs.mkShellNoCC {
        packages = [
          (self.nixosConfigurations.desktop.config.home-manager.users.${userName}.nixvim.package.extend {
            git.enable = true;
          })
        ];
        shellHook = ''
          if [[ ! -f .envrc ]]; then
            echo "use flake .#desktop" > .envrc
          fi
        '';
      };
      formatter.${system} = pkgs.nixfmt;
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              colors
              colors-dark
              inputs
              shell-theme
              system
              userName
              wallpaperPath
              ;
          };
          modules = [
            inputs.disko.nixosModules.default
            ./hosts/desktop/disk-config.nix
            ./hosts/desktop/configuration.nix
            ./modules/nixos
          ];
        };
      };
      homeManagerModules.default = ./modules/home-manager;
    };
}
