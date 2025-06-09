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
    home = {
      file.".config/activitywatch/aw-watcher-afk/aw-watcher-afk.toml" = {
        force = true;
        text = ''
          [aw-watcher-afk]
          timeout = 600
          poll_time = 5

          [aw-watcher-afk-testing]
          #timeout = 20
          #poll_time = 180
        '';
      };
      packages = [pkgs.activitywatch];
    };
    xsession.windowManager.i3.config.startup = [
      {
        always = false;
        command = "${pkgs.activitywatch}/bin/aw-qt";
        notification = false;
      }
    ];
  };
}
