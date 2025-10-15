{ config, lib, ... }:
{
  options.media-server-proxy = {
    enable = lib.mkEnableOption "enable media-server-proxy module";
  };
  config = lib.mkIf config.media-server-proxy.enable {
    services.nginx = {
      enable = true;
      virtualHosts = {
        "jellyfin.local".locations."/".proxyPass = "http://localhost:8096";
        "portainer.local".locations."/".proxyPass = "http://localhost:9000";
        "prowlarr.local".locations."/".proxyPass = "http://localhost:9696";
        "radarr.local".locations."/".proxyPass = "http://localhost:7878";
        "sonarr.local".locations."/".proxyPass = "http://localhost:8989";
        "transmission.local".locations."/".proxyPass = "http://localhost:9091";
      };
    };
    networking.extraHosts = ''
      127.0.0.1 jellyfin.local portainer.local prowlarr.local radarr.local sonarr.local transmission.local
    '';
  };
}
