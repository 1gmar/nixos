{ config, lib, ... }:
{
  options.mouse = {
    enable = lib.mkEnableOption "enable mouse customisations";
  };
  config = lib.mkIf config.mouse.enable {
    services.libinput.mouse = {
      accelProfile = "flat";
      naturalScrolling = true;
    };
  };
}
