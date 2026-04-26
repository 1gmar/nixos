{
  colors-dark,
  config,
  lib,
  pkgs,
  ...
}:
{
  options.console-config = {
    enable = lib.mkEnableOption "enable console configuration";
  };
  config = lib.mkIf config.console-config.enable {
    console = {
      colors =
        with colors-dark;
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
      font = "ter-u18b";
      packages = [ pkgs.terminus_font ];
      keyMap = "us";
    };
  };
}
