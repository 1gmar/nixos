{
  colors,
  config,
  lib,
  ...
}:
let
  utils = import ./utils.nix { inherit lib; };
in
{
  options.polybar.memory = {
    enable = lib.mkEnableOption "enable polybar memory module";
  };
  config = lib.mkIf config.polybar.memory.enable {
    polybar.rightModules = lib.mkOrder 1050 [
      "ram"
      "disk"
    ];
    services.polybar.settings =
      let
        common = {
          format.warn = {
            foreground = colors.red;
            prefix.font = 2;
            text = "<label-warn>";
          };
          label.warn = "%percentage_used:2%%";
          warn.percentage = "90";
        };
        modules = [
          {
            name = "module/disk";
            value = {
              type = "internal/fs";
              format = {
                mounted = {
                  foreground = colors.violet;
                  prefix = {
                    font = "2";
                    text = "󰋊";
                  };
                  text = "<label-mounted>";
                };
                warn.prefix.text = "󰋊";
              };
              interval = "10";
              label.mounted = "%percentage_used:2%%";
            };
          }
          {
            name = "module/ram";
            value = {
              type = "internal/memory";
              format = {
                foreground = colors.violet;
                prefix = {
                  font = "2";
                  text = "󰘚";
                };
                text = "<label>";
                warn.prefix.text = "󰘚";
              };
              interval = "1";
              label.text = "%percentage_used:2%%";
            };
          }
        ];
      in
      utils.modulesWithSharedAttrs modules common;
  };
}
