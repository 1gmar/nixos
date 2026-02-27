{ config, lib, ... }:
{
  options.carapace = {
    enable = lib.mkEnableOption "enable carapace module";
  };
  config = lib.mkIf config.carapace.enable {
    programs.carapace = {
      enable = true;
    };
  };
}
