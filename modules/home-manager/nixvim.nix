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
          lsp.servers.nixd.settings.settings.nixd = {
            nixpkgs.expr = "import (builtins.getFlake \"${config.home.homeDirectory}/nixos\").inputs.nixpkgs { }";
            options.nixos.expr = "(builtins.getFlake \"${config.home.homeDirectory}/nixos\").nixosConfigurations.desktop.options";
          };
        }
      )
    ];
  };
}
