{
  config,
  inputs,
  lib,
  system,
  ...
}:
let
  extension = lib.recursiveUpdate config.nixvim.extensions {
    lsp.servers.nixd.config.settings.nixd =
      let
        nixosOptions = "${thisFlake}.nixosConfigurations.desktop.options";
        thisFlake = "(builtins.getFlake \"${config.home.homeDirectory}/nixos\")";
      in
      {
        nixpkgs.expr = "import ${thisFlake}.inputs.nixpkgs { }";
        options = {
          home-manager.expr = "${nixosOptions}.home-manager.users.type.getSubOptions []";
          nixos.expr = "${nixosOptions}";
        };
      };
    plugins.treesitter.grammarPackages = config.nixvim.treesitterGrammars;
  };
  nvim = inputs.nixvim-1gmar.lib.${system}.mkNixvimWith extension;
in
{
  options.nixvim = with lib.types; {
    enable = lib.mkEnableOption "enable nixvim module";
    extensions = lib.mkOption {
      type = attrsOf anything;
      default = { };
    };
    finalExtensions = lib.mkOption {
      type = attrsOf anything;
      default = extension;
    };
    treesitterGrammars = lib.mkOption {
      type = listOf package;
      default = [ ];
    };
  };
  config = lib.mkIf config.nixvim.enable {
    home.packages = builtins.attrValues nvim;
  };
}
