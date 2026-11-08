{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.activity-watch = {
    enable = lib.mkEnableOption "enable activity-watch module";
  };
  config = lib.mkIf config.activity-watch.enable {
    home.packages = [ pkgs.activitywatch ];
    xdg.configFile."activitywatch/aw-watcher-afk/aw-watcher-afk.toml".source =
      pkgs.writers.writeTOML "aw-watcher-afk.toml"
        {
          aw-watcher-afk = {
            timeout = 600;
            poll_time = 5;
          };
        };
    i3.extraConfig = ''
      exec --no-startup-id ${config.home.profileDirectory}/bin/aw-qt
    '';
    xsession.windowManager.i3.config.startup = [
      {
        always = false;
        command = "${config.home.profileDirectory}/bin/aw-qt";
        notification = false;
      }
    ];
  };
}
