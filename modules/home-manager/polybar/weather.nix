{
  colors,
  config,
  lib,
  runNuC,
  ...
}:
{
  options.polybar.weather = {
    enable = lib.mkEnableOption "enable polybar weather module";
  };
  config = lib.mkIf config.polybar.weather.enable {
    polybar.rightModules = lib.mkOrder 1040 [ "weather" ];
    services.polybar.settings = {
      "module/weather" = {
        type = "custom/script";
        exec = runNuC [
          "${config.home.profileDirectory}/bin/wthrr"
          "| lines"
          "| get 3"
          "| split row `,`"
          "| each { split row -r `\\s+` }"
          "| get 0.1 1.1"
          "| str join `  `"
        ];
        format = {
          fail = "<label-fail>";
          text = "<label>";
        };
        interval = {
          fail = "10";
          text = "600";
        };
        label = {
          fail = {
            font = "2";
            foreground = colors.red;
            text = "󱯻";
          };
          text = "%output:8%";
        };
      };
    };
  };
}
