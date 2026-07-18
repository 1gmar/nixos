{ config, lib, ... }:
{
  options.screen-scaling = {
    enable = lib.mkEnableOption "enable screen scaling module";
    dpi = lib.mkOption {
      type = lib.types.ints.between 50 500;
    };
  };
  config = lib.mkIf config.screen-scaling.enable {
    services.xserver = lib.mkIf config.xserver.enable {
      dpi = config.screen-scaling.dpi;
      displayManager.importedVariables = [
        "GDK_SCALE"
        "GDK_DPI_SCALE"
        "QT_AUTO_SCREEN_SCALE_FACTOR"
      ];
    };
    environment.variables = {
      GDK_SCALE = "2";
      GDK_DPI_SCALE = "0.5";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    };
  };
}
