{
  colors,
  config,
  inputs,
  ln-tty-vim,
  lib,
  pkgs,
  system,
  userName,
  wallpaperPath,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  options.home-manager-config = {
    enable = lib.mkEnableOption "enable home manager";
    home-file = lib.mkOption {
      type = lib.types.path;
      description = "Path to the home.nix file.";
    };
  };
  config = lib.mkIf config.home-manager-config.enable {
    home-manager = {
      extraSpecialArgs = {
        inherit
          colors
          inputs
          ln-tty-vim
          system
          userName
          wallpaperPath
          ;
        install-fonts = pkgs.callPackage ./fonts/packages/install-font.nix { };
        sysConfig = config;
      };
      sharedModules = [
        inputs.self.homeManagerModules.default
      ];
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${userName} = config.home-manager-config.home-file;
    };
  };
}
