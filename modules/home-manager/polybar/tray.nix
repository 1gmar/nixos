{
  config,
  lib,
  ...
}: {
  options.tray = {
    enable = lib.mkEnableOption "enable polybar tray module";
  };
  config = lib.mkIf config.tray.enable {
    polybar.rightModules = lib.mkOrder 1030 ["tray"];
    services.polybar.settings = {
      "module/tray" = {
        type = "internal/tray";
        format.suffix = "│";
        tray = {
          size = "70%";
          spacing = "2";
        };
      };
    };
  };
}
