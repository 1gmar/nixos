{ config, lib, ... }:
{
  options.mouse-config = {
    enable = lib.mkEnableOption "enable mouse customisations";
  };
  config = lib.mkIf config.mouse-config.enable {
    services.libinput.mouse = {
      accelProfile = "flat";
      naturalScrolling = true;
    };
  };
}
