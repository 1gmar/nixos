{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.wthrr = {
    enable = lib.mkEnableOption "enable wthrr module";
  };
  config = lib.mkIf config.wthrr.enable {
    home.packages = [ pkgs.wthrr ];
    xdg.configFile."weathercrab/wthrr.ron" = {
      force = true;
      text = ''
        (
           address: "Chisinau,MD",
           language: "en_US",
           forecast: [],
           units: (
             temperature: celsius,
             speed: kmh,
             time: military,
             precipitation: probability,
           ),
           gui: (
             border: rounded,
             color: default,
             graph: (
               style: lines(solid),
               rowspan: double,
               time_indicator: true,
             ),
             greeting: false,
           ),
        )
      '';
    };
  };
}
