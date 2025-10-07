{
  colors,
  config,
  lib,
  ...
}: {
  options.memory = {
    enable = lib.mkEnableOption "enable polybar memory module";
  };
  config = lib.mkIf config.memory.enable {
    polybar.rightModules = lib.mkOrder 1050 ["ram" "disk"];
    services.polybar.settings = {
      "module/disk" = {
        type = "internal/fs";
        format = {
          mounted = {
            foreground = colors.violet;
            prefix = {
              font = "2";
              text = "󰋊";
            };
            text = "<label-mounted>";
          };
          warn = {
            foreground = colors.red;
            prefix = {
              font = "2";
              text = "󰋊";
            };
            text = "<label-warn>";
          };
        };
        interval = "10";
        label = {
          mounted = "%percentage_used:2%%";
          warn = "%percentage_used:2%%";
        };
        warn.percentage = "90";
      };
      "module/ram" = {
        type = "internal/memory";
        format = {
          foreground = colors.violet;
          prefix = {
            font = "2";
            text = "󰘚";
          };
          text = "<label>";
          warn = {
            foreground = colors.red;
            prefix = {
              font = "2";
              text = "󰘚";
            };
            text = "<label-warn>";
          };
        };
        interval = "1";
        label = {
          text = "%percentage_used:2%%";
          warn = "%percentage_used:2%%";
        };
        warn.percentage = "90";
      };
    };
  };
}
