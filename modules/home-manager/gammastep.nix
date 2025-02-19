{
  lib,
  config,
  ...
}: {
  options = {
    gammastep.enable = lib.mkEnableOption "enable gammastep module";
  };
  config = lib.mkIf config.gammastep.enable {
    services.gammastep = {
      enable = true;
      dawnTime = "06:00-07:00";
      duskTime = "21:00-22:00";
      latitude = 47.0;
      longitude = 28.5;
      provider = "manual";
      settings = {
        general.adjustment-method = "randr";
        randr.screen = 0;
      };
      temperature = {
        day = 6500;
        night = 2500;
      };
      tray = true;
    };
  };
}
