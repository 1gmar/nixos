{
  colors,
  config,
  inputs,
  system,
  userName,
  wallpaperPath,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit colors inputs system userName wallpaperPath;
      sysConfig = config;
    };
    sharedModules = [
      inputs.self.homeManagerModules.default
    ];
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${userName} = ./home.nix;
  };
}
