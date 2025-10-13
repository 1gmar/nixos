{
  config,
  lib,
  wallpaperPath,
  ...
}: {
  options.feh = {
    enable = lib.mkEnableOption "enable feh module";
  };
  config = lib.mkIf config.feh.enable {
    programs.feh.enable = true;
    xsession.windowManager.i3.config.startup = lib.mkIf config.i3wm.enable [
      {
        always = true;
        command = "${config.home.profileDirectory}/bin/feh --bg-fill ${wallpaperPath}";
        notification = false;
      }
    ];
  };
}
