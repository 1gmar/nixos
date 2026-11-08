{
  colors,
  config,
  lib,
  ...
}:
{
  options.flameshot = {
    enable = lib.mkEnableOption "enable flameshot module";
  };
  config = lib.mkIf config.flameshot.enable {
    services.flameshot = {
      enable = true;
      settings = {
        General = {
          disabledTrayIcon = true;
          showAbortNotification = false;
          showStartupLaunchMessage = false;
          uiColor = colors.background;
          contrastUiColor = colors.yellow;
        };
      };
    };
    i3.extraConfig = ''
      bindsym Print exec --no-startup-id ${config.home.profileDirectory}/bin/flameshot gui
    '';
    xsession.windowManager.i3.config.keybindings = {
      "Print" = "exec flameshot gui";
    };
  };
}
