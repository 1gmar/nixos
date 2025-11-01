{ config, lib, ... }:
{
  options.pairdrop = {
    enable = lib.mkEnableOption "enable pairdrop module";
  };
  config = lib.mkIf config.pairdrop.enable {
    services.pairdrop = {
      enable = true;
    };
  };
}
