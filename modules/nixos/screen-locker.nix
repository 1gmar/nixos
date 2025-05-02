{
  lib,
  config,
  pkgs,
  wallpaperPath,
  ...
}: {
  options.screen-locker = {
    enable = lib.mkEnableOption "enable screen-locker module";
  };
  config = lib.mkIf config.screen-locker.enable {
    programs = {
      i3lock.enable = true;
      xss-lock = {
        enable = true;
        extraOptions = ["--transfer-sleep-lock"];
        lockerCommand = "${pkgs.i3lock}/bin/i3lock --nofork --ignore-empty-password --image=${wallpaperPath} --show-keyboard-layout";
      };
    };
  };
}
