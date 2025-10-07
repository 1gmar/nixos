{
  colors,
  config,
  lib,
  pkgs,
  ...
}: {
  options.datetime = {
    enable = lib.mkEnableOption "enable polybar datetime module";
  };
  config = lib.mkIf config.datetime.enable {
    polybar.rightModules = lib.mkOrder 1080 ["date" "time"];
    services.polybar.settings = {
      "module/date" = {
        type = "custom/script";
        exec = "${pkgs.coreutils-full}/bin/date +%a%-e";
        format = {
          foreground = colors.yellow;
          text = "<label>";
        };
        interval = "1";
        label = "%output%";
      };
      "module/time" = {
        type = "custom/script";
        exec = "${pkgs.coreutils-full}/bin/date +%H:%M:%S";
        format = {
          foreground = colors.green;
          text = "<label>";
        };
        interval = "1";
        label = "%output%";
      };
    };
  };
}
