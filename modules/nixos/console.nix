{
  colors,
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
        with colors;
        map (x: builtins.substring 1 (-1) x) [
          darkBlack
          red
          green
          yellow
          blue
          magenta
          cyan
          backgroundHigh
          black
          orange
          foregroundEmph
          text
          foreground0
          violet
          secondaryContent
          background
        ];
      font = "ter-u18b";
      packages = [ pkgs.terminus_font ];
      keyMap = "us";
    };
  };
}
