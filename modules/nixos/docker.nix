{ config, lib, ... }:
{
  options.docker = {
    enable = lib.mkEnableOption "enable docker module";
  };
  config = lib.mkIf config.docker.enable {
    hardware.nvidia-container-toolkit = lib.mkIf config.nvidia.enable {
      enable = true;
      device-name-strategy = "uuid";
    };
    virtualisation.docker.enable = true;
  };
}
