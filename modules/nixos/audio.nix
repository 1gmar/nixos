{ config, lib, ... }:
{
  options.audio = {
    enable = lib.mkEnableOption "enable audio module";
  };
  config = lib.mkIf config.audio.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };
}
