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
    xsession.windowManager.i3.config.keybindings = lib.mkIf config.i3wm.enable {
      "Print" = "exec flameshot gui";
    };
  };
}
