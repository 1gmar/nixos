{ config, lib, ... }:
{
  options.network-config = {
    enable = lib.mkEnableOption "enable networking module";
  };
  config = lib.mkIf config.network-config.enable {
    networking = {
      firewall = {
        enable = true;
        extraCommands = ''
          iptables -I nixos-fw-log-refuse -s 192.168.100.0/24 -j nixos-fw-accept
        '';
      };
      hostName = "nixos";
      networkmanager.enable = true;
    };
  };
}
