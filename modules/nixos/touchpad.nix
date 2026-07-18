{ config, lib, ... }:
{
  options.touchpad-config = {
    enable = lib.mkEnableOption "enable touchpad customisations";
  };
  config = lib.mkIf config.touchpad-config.enable {
    services.libinput.touchpad = {
      accelProfile = "adaptive";
      accelSpeed = "0.5";
      naturalScrolling = true;
      tapping = false;
    };
  };
}
