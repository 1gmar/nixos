{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.docker = {
    enable = lib.mkEnableOption "enable docker module";
  };
  config = lib.mkIf config.docker.enable {
    environment.systemPackages = [ pkgs.docker-compose ];
    hardware.nvidia-container-toolkit = lib.mkIf config.nvidia.enable {
      enable = true;
      device-name-strategy = "uuid";
    };
    virtualisation.docker.enable = true;
  };
}
