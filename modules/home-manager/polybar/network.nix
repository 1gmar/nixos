{
  colors,
  config,
  lib,
  ...
}: {
  options.network = {
    enable = lib.mkEnableOption "enable polybar network module";
  };
  config = lib.mkIf config.network.enable {
    polybar.centerModules = lib.mkOrder 1050 ["network"];
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
          connected = "%downspeed:10%󰜮%upspeed:10%󰜷";
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
