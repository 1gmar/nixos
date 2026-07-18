{
  config,
  lib,
  pkgs,
  wallpaperPath,
  ...
}:
{
  options.screen-locker = {
    enable = lib.mkEnableOption "enable screen-locker module";
    resolution = lib.mkOption {
      type = lib.types.strMatching "^[0-9]{3,4}x[0-9]{3,4}$";
      default = null;
    };
  };
  config = lib.mkIf config.screen-locker.enable {
    assertions = [
      {
        assertion = config.xserver.enable;
        descriptin = "Current implementation of screen locker uses i3lock which requires X11";
      }
    ];
    programs =
      let
        resolution = config.screen-locker.resolution;
        image = if resolution == null then wallpaperPath else "${scaled-image}/wallpaper-scaled.png";
        scaled-image = pkgs.runCommand "wallpaper-scaled" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
          mkdir $out
          magick ${wallpaperPath} -resize ${resolution}^ -gravity center -extent ${resolution} $out/wallpaper-scaled.png
        '';
      in
      {
        i3lock.enable = true;
        xss-lock = {
          enable = true;
          extraOptions = [ "--transfer-sleep-lock" ];
          lockerCommand = "${pkgs.i3lock}/bin/i3lock --nofork --ignore-empty-password --image=${image} --show-keyboard-layout";
        };
      };
  };
}
