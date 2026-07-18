{
  colors,
  config,
  lib,
  ...
}:
{
  options.polybar.battery = {
    enable = lib.mkEnableOption "enable polybar battery module";
  };
  config = lib.mkIf config.polybar.battery.enable {
    polybar.rightModules = lib.mkOrder 1075 [
      "battery"
    ];
    services.polybar.settings."module/battery" = {
      type = "internal/battery";
      adapter = "ADP1";
      battery = "BAT0";
      full.at = 100;
      low.at = 20;
      format = {
        charging = {
          foreground = colors.green;
          text = "<ramp-capacity>";
        };
        discharging = {
          foreground = colors.yellow;
          text = "<ramp-capacity>";
        };
        full = {
          foreground = colors.blue;
          font = 2;
          text = "󱰻";
        };
        low = {
          foreground = colors.red;
          text = "<ramp-capacity>";
        };
      };
      ramp.capacity = {
        font = 2;
        text = [
          "󱃍"
          "󰁻"
          "󰁽"
          "󰁿"
          "󰂁"
          "󰁹"
        ];
      };
    };
  };
}
