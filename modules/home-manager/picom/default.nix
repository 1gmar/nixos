{ lib, config, ... }:
{
  options.picom = {
    enable = lib.mkEnableOption "enable picom module";
  };
  config = lib.mkIf config.picom.enable {
    services.picom.enable = true;
    xdg.configFile."picom/picom.conf".source = ./picom.conf;
  };
}
