{ config, lib, ... }: {
  options.clight = {
    enable = lib.mkEnableOption "enable clight module";
  };
  config = lib.mkIf config.clight.enable {
    services.clight = {
      enable = true;
      temperature = {
        day = 6500;
        night = 2300;
      };
      settings = {
        resumedelay = 5;
        backlight = {
          hotplug_delay = 5;
          ac_timeouts = [
            600
            2700
            100
          ];
          batt_timeouts = [
            1200
            5400
            200
          ];
        };
        daytime = {
          sunrise = "6:00";
          sunset = "21:00";
        };
        dimmer.disabled = true;
        dpms.disabled = true;
        gamma.long_transition = true;
        inhibit.disabled = true;
        keyboard.disabled = true;
        screen.disabled = true;
        sensor = {
          devname = "iio:device0";
          ac_regression_points = [
            0.3
            0.35
            0.45
            0.55
            0.61
            0.74
            0.81
            0.88
            0.93
            0.97
            1.0
          ];
          batt_regression_points = [
            0.15
            0.2
            0.27
            0.36
            0.52
            0.59
            0.65
            0.71
            0.75
            0.78
            0.80
          ];
        };
      };
    };
  };
}
