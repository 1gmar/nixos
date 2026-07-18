{
  config,
  inputs,
  lib,
  ln-tty-vim,
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
  nvim = inputs.nixvim-1gmar.packages.${system}.default.extend extension;
  tty-vim = inputs.nixvim-1gmar.packages.${system}.tty-vim.extend extension;
in
{
  options.nixvim = with lib.types; {
    enable = lib.mkEnableOption "enable nixvim module";
    extensions = lib.mkOption {
      type = attrsOf anything;
      default = { };
    };
    package = lib.mkOption {
      type = package;
      default = nvim;
    };
    package-tvim = lib.mkOption {
      type = package;
      default = tty-vim;
    };
    treesitterGrammars = lib.mkOption {
      type = listOf package;
      default = [ ];
    };
  };
  config = lib.mkIf config.nixvim.enable {
    home.packages = [
      config.nixvim.package
      (ln-tty-vim config.nixvim.package-tvim)
    ];
  };
}
