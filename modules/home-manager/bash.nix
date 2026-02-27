{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    bash.enable = lib.mkEnableOption "enable bash module";
  };
  config = lib.mkIf config.bash.enable {
    nixvim.treesitterGrammars = [ pkgs.vimPlugins.nvim-treesitter.builtGrammars.bash ];
    home.shell.enableBashIntegration = true;
    programs.bash = {
      enable = true;
    };
  };
}
