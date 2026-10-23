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
    boot = {
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "systemd.show_status=false"
        "rd.udev.log_level=3"
        "rd.systemd.show_status=auto"
      ];
    };
    console = {
      colors =
        with theme.light.gui;
        map (x: builtins.substring 1 (-1) x) [
          background
          red
          green
          yellow
          blue
          magenta
          cyan
          black
          backHighlight
          orange
          highlight
          primaryContent
          brightBlue
          violet
          secondaryContent
          brightBlack
        ];
      font = config.console-config.font;
      packages = [ pkgs.terminus_font ];
      keyMap = lib.mkIf (!config.console-config.use-xkb-config) "us";
      useXkbConfig = config.console-config.use-xkb-config;
    };
  };
}
