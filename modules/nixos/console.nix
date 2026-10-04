{
  config,
  lib,
  pkgs,
  theme,
  ...
}:
{
  options.console-config = {
    enable = lib.mkEnableOption "enable console configuration";
    font = lib.mkOption {
      type = with lib.types; nullOr (either str path);
    };
    use-xkb-config = lib.mkEnableOption "use xkb configuration";
  };
  config = lib.mkIf config.console-config.enable {
    console = {
      colors =
        with theme.dark.gui;
        map (x: builtins.substring 1 (-1) x) [
          backHighlight
          red
          green
          yellow
          blue
          magenta
          cyan
          white
          background
          orange
          secondaryContent
          brightYellow
          primaryContent
          violet
          highlight
          brightWhite
        ];
      font = config.console-config.font;
      packages = [ pkgs.terminus_font ];
      keyMap = lib.mkIf (!config.console-config.use-xkb-config) "us";
      useXkbConfig = config.console-config.use-xkb-config;
    };
  };
}
