{
  config,
  lib,
  pkgs,
  wallpaperPath,
  ...
}:
{
  options.xserver = {
    enable = lib.mkEnableOption "enable xserver module";
    xkb-options = lib.mkOption {
      type = lib.types.commas;
      default = "";
    };
  };
  config = lib.mkIf config.xserver.enable {
    services = {
      displayManager.defaultSession = "none+i3";
      xserver = {
        config = lib.mkAfter ''
          Section "ServerFlags"
              Option "BlankTime"   "0"
              Option "OffTime"     "0"
              Option "StandbyTime" "0"
              Option "SuspendTime" "0"
          EndSection
        '';
        displayManager.lightdm = {
          background = wallpaperPath;
          enable = true;
        };
        enable = true;
        excludePackages = [ pkgs.xterm ];
        exportConfiguration = true;
        windowManager.i3.enable = true;
        xkb = {
          layout = "us";
          options = config.xserver.xkb-options;
        };
      };
    };
  };
}
