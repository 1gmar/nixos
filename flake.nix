{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-26.05";
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
    };
    color-themes.url = "github:1gmar/color-themes";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      colors = inputs.color-themes.solarized.light;
      colors-dark = inputs.color-themes.solarized.dark;
      ln-tty-vim =
        pkg:
        pkgs.runCommandLocal "tty-vim" { } ''
          mkdir -p $out/bin
          ln -s ${pkg}/bin/nvim $out/bin/tvim
        '';
      pkgs = import nixpkgs { inherit system; };
      shell-theme = ./modules/home-manager/nushell/solarized-light.nu;
      system = "x86_64-linux";
      userName = "igmar";
      wallpaperPath = ./anime-sky.png;
      mkShellFor =
        host:
        pkgs.mkShellNoCC {
          packages =
            let
              tvim =
                self.nixosConfigurations.${host}.config.home-manager.users.${userName}.nixvim.package-tvim.extend
                  {
                    git.enable = true;
                  };
            in
            [
              (self.nixosConfigurations.${host}.config.home-manager.users.${userName}.nixvim.package.extend {
                git.enable = true;
              })
              (ln-tty-vim tvim)
            ];
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
              colors
              colors-dark
              inputs
              ln-tty-vim
              shell-theme
              system
              userName
              wallpaperPath
              ;
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
