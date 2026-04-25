{ config, lib, ... }:
{
  options.unfree-apps = {
    enable = lib.mkEnableOption "enable unfree-apps module";
    pkg-names = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
    };
  };
  config = lib.mkIf config.unfree-apps.enable {
    nixpkgs.config.allowUnfreePredicate =
      pkg: builtins.elem (lib.getName pkg) config.unfree-apps.pkg-names;
  };
}
