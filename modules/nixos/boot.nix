{ config, lib, ... }:
{
  options.boot-config = {
    enable = lib.mkEnableOption "enable boot customisations";
    kernelModules = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
    };
  };
  config = lib.mkIf config.boot-config.enable {
    boot = {
      kernelModules = config.boot-config.kernelModules;
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
