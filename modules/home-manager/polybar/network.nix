{
  colors,
  config,
  lib,
  ...
}:
{
  options.polybar.network = {
    enable = lib.mkEnableOption "enable polybar network module";
  };
  config = lib.mkIf config.polybar.network.enable {
    polybar.centerModules = lib.mkOrder 1050 [ "network" ];
    services.polybar.settings = {
      "module/network" = {
        type = "internal/network";
        format.connected = {
          foreground = colors.yellow;
          text = "<label-connected>";
        };
        format.disconnected = {
          foreground = colors.red;
          text = "<label-disconnected>";
        };
        interface = "enp5s0";
        interval = "0.5";
        label = {
          connected = "%downspeed:10%%{T2}󰜮%{T-}%upspeed:10%%{T2}󰜷%{T-}";
          disconnected = {
            prefix = {
              font = "2";
              text = "󰲛";
            };
            text = "Disconnected";
          };
        };
      };
    };
  };
}
