{
  lib,
  config,
  pkgs,
  wallpaperPath,
  ...
}: {
  options = {
    screen-locker.enable = lib.mkEnableOption "enable screen-locker module";
  };
  config = lib.mkIf config.screen-locker.enable {
    services.screen-locker = {
      enable = true;
      inactiveInterval = 10;
      lockCmd = "${pkgs.i3lock}/bin/i3lock --nofork --ignore-empty-password --image=${wallpaperPath}";
      xss-lock = {
        extraOptions = ["--transfer-sleep-lock"];
        screensaverCycle = 600;
      };
    };
  };
}
