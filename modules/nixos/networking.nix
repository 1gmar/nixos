{ config, lib, ... }:
{
  options.network-config = {
    enable = lib.mkEnableOption "enable networking module";
    hostname = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
    };
  };
  config = lib.mkIf config.network-config.enable {
    networking = {
      firewall = {
        enable = true;
        extraCommands = ''
          iptables -I nixos-fw-log-refuse -s 192.168.100.0/24 -j nixos-fw-accept
        '';
      };
      hostName = config.network-config.hostname;
      networkmanager.enable = true;
    };
  };
}
