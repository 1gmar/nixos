{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-26.05";
    color-themes.url = "github:1gmar/color-themes";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim-1gmar = {
      url = "github:1gmar/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.color-themes.follows = "color-themes";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim-1gmar,
      ...
    }@inputs:
    let
      theme = inputs.color-themes.solarized;
      pkgs = import nixpkgs { inherit system; };
      shell-theme = ./modules/home-manager/nushell/solarized-light.nu;
      system = "x86_64-linux";
      userName = "igmar";
      wallpaperPath = ./anime-sky.png;
      mkShellFor =
        host:
        pkgs.mkShellNoCC {
          packages = builtins.attrValues (
            nixvim-1gmar.lib.${system}.mkNixvimWith (
              self.nixosConfigurations.${host}.config.home-manager.users.${userName}.nixvim.finalExtensions
              // {
                git.enable = true;
              }
            )
          );
          shellHook = ''
            if [[ ! -f .envrc ]]; then
              echo "use flake .#${host}" > .envrc
            fi
          '';
        };
      mkNixosConfigFor =
        host:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              shell-theme
              system
              theme
              userName
              wallpaperPath
              ;
            colors = theme.light.gui;
          };
          modules = [
            inputs.disko.nixosModules.default
            ./hosts/${host}/disk-config.nix
            ./hosts/${host}/configuration.nix
            ./modules/nixos
          ];
        };
    in
    {
      devShells.${system} = {
        desktop = mkShellFor "desktop";
        macbook = mkShellFor "macbook";
      };
      formatter.${system} = pkgs.nixfmt;
      nixosConfigurations = {
        desktop = mkNixosConfigFor "desktop";
        macbook = mkNixosConfigFor "macbook";
      };
      homeManagerModules.default = ./modules/home-manager;
    };
}
