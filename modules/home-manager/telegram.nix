{
  config,
  lib,
  pkgs,
  sysConfig,
  ...
}:
{
  options.telegram = {
    enable = lib.mkEnableOption "enable telegram module";
  };
  config = lib.mkIf config.telegram.enable {
    home.packages = [ pkgs.telegram-desktop ];
    i3.extraConfig = ''
      assign [class="TelegramDesktop"] ${sysConfig.i3.workspaces.messenger}
      exec --no-startup-id ${config.home.profileDirectory}/bin/Telegram
    '';
    xsession.windowManager.i3.config.startup = [
      {
        always = false;
        command = "${config.home.profileDirectory}/bin/Telegram";
        notification = false;
      }
    ];
  };
}
