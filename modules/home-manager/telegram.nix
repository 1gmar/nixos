{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.telegram = {
    enable = lib.mkEnableOption "enable telegram module";
  };
  config = lib.mkIf config.telegram.enable {
    home.packages = [ pkgs.telegram-desktop ];
    xsession.windowManager.i3.config.startup = [
      {
        always = false;
        command = "${config.home.profileDirectory}/bin/Telegram";
        notification = false;
      }
    ];
  };
}
