{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    bash.enable = lib.mkEnableOption "enable bash module";
  };
  config = lib.mkIf config.bash.enable {
    nixvim.treesitterGrammars = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.bash];
    programs.bash = {
      enable = true;
    };
  };
}
