{
  config,
  lib,
  wallpaperPath,
  ...
}:
{
  options.xserver = {
    enable = lib.mkEnableOption "enable xserver module";
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
          greeters.enso = {
            blur = true;
            enable = true;
          };
        };
        enable = true;
        exportConfiguration = true;
        windowManager.i3.enable = true;
        xkb.layout = "us";
      };
    };
  };
}
