{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}:
let
  myPackage = inputs.nixvim-1gmar.packages.${system}.default.extend (
    lib.recursiveUpdate config.nixvim.extensions {
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
    }
  );
  dark-version = myPackage.extend {
    opts.background = "dark";
    plugins.lualine.settings.options.theme = "solarized_dark";
  };
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
      default = myPackage;
    };
    package-dvim = lib.mkOption {
      type = package;
      default = dark-version;
    };
    treesitterGrammars = lib.mkOption {
      type = listOf package;
      default = [ ];
    };
  };
  config = lib.mkIf config.nixvim.enable {
    home.packages = [
      config.nixvim.package
      (pkgs.runCommandLocal "dvim" { } ''
        mkdir -p $out/bin
        ln -s ${config.nixvim.package-dvim}/bin/nvim $out/bin/dvim
      '')
    ];
  };
}
