{
  config,
  lib,
  pkgs,
  ...
}:
let
  log-file = "/tmp/radeontop.log";
in
{
  options.polybar.gpu.radeongpu = {
    enable = lib.mkEnableOption "enable polybar radeon gpu module";
  };
  config = lib.mkIf config.polybar.gpu.radeongpu.enable {
    polybar.gpu = {
      gpu-cmd = {
        exec =
          "${pkgs.nushell}/bin/nu -n -c "
          + "'open ${log-file} | lines | last | split row `,` | get 1 "
          + "| split row -r `\\s+` | last | str replace -r `\\.\\d+` ``'";
        interval = {
          fail = 5;
          text = 1;
        };
        label.text = "%output:3%";
      };
      mem-cmd = {
        exec =
          "${pkgs.nushell}/bin/nu -n -c "
          + "'open ${log-file} | lines | last | split row `,` | get 12 "
          + "| split row -r `\\s+` | get 2 | str replace -r `\\.\\d+%` ``'";
        interval = {
          fail = 5;
          text = 1;
        };
      };
    };
    systemd.user = {
      services = {
        radeontop-log = {
          Install.WantedBy = [ "graphical-session.target" ];
          Service = {
            ExecStart = "${pkgs.radeontop}/bin/radeontop -d ${log-file}";
            Type = "exec";
          };
          Unit = {
            Description = "Log radeon gpu metrics";
            PartOf = [ "graphical-session.target" ];
          };
        };
        radeontop-log-cleanup = {
          Service = {
            ExecStart =
              "${pkgs.nushell}/bin/nu -n -c "
              + "'open ${log-file} | lines | last | $in + (char nl) | save -f ${log-file}'";
            Type = "oneshot";
          };
          Unit.Description = "Cleanup the radeontop log";
        };
      };
      timers.radeontop-log-cleanup = {
        Install.WantedBy = [ "timers.target" ];
        Timer = {
          OnActiveSec = "5min";
          OnUnitActiveSec = "3min";
        };
        Unit.Description = "Cleanup timer for radeontop log";
      };
    };
  };
}
