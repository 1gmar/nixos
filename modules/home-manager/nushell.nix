{
  config,
  lib,
  pkgs,
  ...
}: {
  options.nushell = {
    enable = lib.mkEnableOption "enable nushell module";
  };
  config = lib.mkIf config.nushell.enable {
    nixvim.treesitterGrammars = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.nu];
    programs.nushell = {
      enable = true;
    };
  };
}
