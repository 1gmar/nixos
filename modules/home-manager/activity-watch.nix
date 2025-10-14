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
    home = {
      file.".config/activitywatch/aw-watcher-afk/aw-watcher-afk.toml" = {
        source = pkgs.writers.writeTOML "aw-watcher-afk.toml" {
          aw-watcher-afk = {
            timeout = 600;
            poll_time = 5;
          };
        };
      };
      packages = [ pkgs.activitywatch ];
    };
    xsession.windowManager.i3.config.startup = lib.mkIf config.i3wm.enable [
      {
        always = false;
        command = "${config.home.profileDirectory}/bin/aw-qt";
        notification = false;
      }
    ];
  };
}
