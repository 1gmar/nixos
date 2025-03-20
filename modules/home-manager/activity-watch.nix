{
  config,
  lib,
  pkgs,
  ...
}: {
  options.activity-watch = {
    enable = lib.mkEnableOption "enable activity-watch module";
  };
  config = lib.mkIf config.activity-watch.enable {
    services.activitywatch = {
      enable = true;
      watchers = {
        aw-watcher-afk = {
          package = pkgs.activitywatch;
          settings = {
            aw-watcher-afk = {
              poll_time = 5;
              timeout = 600;
            };
          };
        };
        aw-watcher-window = {
          package = pkgs.activitywatch;
        };
      };
    };
    systemd.user.targets.activitywatch = {
      Unit = {
        After = lib.mkForce ["graphical-session.target"];
        Requires = lib.mkForce ["graphical-session.target"];
      };
      Install.WantedBy = lib.mkForce ["graphical-session.target"];
    };
  };
}
