{ config, lib, ... }:
{
  options.nvidia = {
    enable = lib.mkEnableOption "enable nvidia drivers";
  };
  config = lib.mkIf config.nvidia.enable {
    hardware.nvidia = {
      modesetting.enable = true;
      open = false;
      powerManagement.enable = true;
      videoAcceleration = true;
    };
    services.xserver.videoDrivers = [ "nvidia" ];
    unfree-apps.pkg-names = [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
    ];
  };
}
