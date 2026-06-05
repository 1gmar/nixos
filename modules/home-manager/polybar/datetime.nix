{
  colors,
  config,
  lib,
  pkgs,
  ...
}:
let
  utils = import ./utils.nix { inherit lib; };
in
{
  options.polybar.datetime = {
    enable = lib.mkEnableOption "enable polybar datetime module";
  };
  config = lib.mkIf config.polybar.datetime.enable {
    polybar.rightModules = lib.mkOrder 1080 [
      "date"
      "time"
    ];
    services.polybar.settings =
      let
        common = {
          type = "custom/script";
          format.text = "<label>";
          interval = "1";
          label = "%output%";
        };
        modules = [
          {
            name = "module/date";
            value = {
              exec = "${pkgs.coreutils-full}/bin/date +%a%-e";
              format.foreground = colors.yellow;
            };
          }
          {
            name = "module/time";
            value = {
              exec = "${pkgs.coreutils-full}/bin/date +%H:%M:%S";
              format.foreground = colors.green;
            };
          }
        ];
      in
      utils.modulesWithSharedAttrs modules common;
  };
}
