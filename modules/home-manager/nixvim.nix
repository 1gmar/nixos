{
  config,
  inputs,
  lib,
  system,
  ...
}: {
  options.nixvim = with lib.types; {
    enable = lib.mkEnableOption "enable nixvim module";
    extensions = lib.mkOption {
      type = attrsOf anything;
      default = {};
    };
    treesitterGrammars = lib.mkOption {
      type = listOf package;
      default = [];
    };
  };
  config = lib.mkIf config.nixvim.enable {
    home.packages = [
      (
        inputs.nixvim-1gmar.packages.${system}.default.extend
        (
          lib.mergeAttrs
          config.nixvim.extensions
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
            plugins.treesitter.grammarPackages = config.nixvim.treesitterGrammars;
          }
        )
      )
    ];
  };
}
