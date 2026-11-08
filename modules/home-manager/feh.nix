{
  config,
  lib,
  wallpaperPath,
  ...
}:
{
  options.feh = {
    enable = lib.mkEnableOption "enable feh module";
  };
  config = lib.mkIf config.feh.enable {
    programs.feh.enable = true;
    i3.extraConfig = ''
      exec_always --no-startup-id ${config.home.profileDirectory}/bin/feh --bg-fill ${wallpaperPath}
    '';
    xsession.windowManager.i3.config.startup = [
      {
        always = true;
        command = "${config.home.profileDirectory}/bin/feh --bg-fill ${wallpaperPath}";
        notification = false;
      }
    ];
  };
}
