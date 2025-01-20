{inputs, ...}: {
  imports = [
    inputs.stylix.nixosModules.stylix
    ./main-user.nix
    ./stylix.nix
  ];
}
