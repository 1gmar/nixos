{
  colors,
  config,
  lib,
  ...
}:
{
  options.polybar.network = {
    enable = lib.mkEnableOption "enable polybar network module";
    interface = lib.mkOption {
      type = lib.types.str;
    };
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
          prefix = {
            font = "2";
            text = "󰲛";
          };
          text = "<label-disconnected>";
        };
        interface = config.polybar.network.interface;
        interval = "0.5";
        label = {
          connected = "%downspeed:9%%{T2}󰜮%{T-}%upspeed:9%%{T2}󰜷%{T-}";
          disconnected = "Disconnected";
        };
      };
    };
  };
}
