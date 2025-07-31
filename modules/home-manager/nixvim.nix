{
  config,
  inputs,
  lib,
  system,
  ...
}: {
  options.nixvim = {
    enable = lib.mkEnableOption "enable nixvim module";
  };
  config = lib.mkIf config.nixvim.enable {
    home.packages = [
      (
        inputs.nixvim-1gmar.packages.${system}.default.extend
        {
          lsp.servers.nixd.settings.settings.nixd = let
            nixosOptions = "${thisFlake}.nixosConfigurations.desktop.options";
            thisFlake = "(builtins.getFlake \"${config.home.homeDirectory}/nixos\")";
          in {
            nixpkgs.expr = "import ${thisFlake}.inputs.nixpkgs { }";
            options = {
              home-manager.expr = "${nixosOptions}.home-manager.users.type.getSubOptions []";
              nixos.expr = "${nixosOptions}";
            };
          };
        }
      )
    ];
  };
}
