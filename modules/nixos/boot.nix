{ config, lib, ... }:
{
  options.boot-config = {
    enable = lib.mkEnableOption "enable boot customisations";
  };
  config = lib.mkIf config.boot-config.enable {
    boot = {
      kernelModules = [
        "coretemp"
        "nct6775"
      ];
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          configurationLimit = 5;
        };
      };
    };
  };
}
