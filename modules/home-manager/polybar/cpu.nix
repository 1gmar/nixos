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
  options.polybar.cpu = {
    enable = lib.mkEnableOption "enable polybar cpu module";
  };
  config = lib.mkIf config.polybar.cpu.enable {
    polybar.centerModules = lib.mkOrder 1040 [
      "cpu"
      "cpu-fan"
      "cpu-temp"
    ];
    services.polybar.settings =
      let
        common = {
          type = "custom/script";
          format = {
            foreground = colors.blue;
            text = "<label>";
          };
          interval = "0.5";
          label = "%output:4%";
        };
        modules = [
          {
            name = "module/cpu";
            value = {
              type = "internal/cpu";
              format = {
                prefix = {
                  font = "2";
                  text = "󰍛";
                };
                warn = {
                  foreground = colors.red;
                  prefix = {
                    font = "2";
                    text = "󰍛";
                  };
                  text = "<label-warn>";
                };
              };
              label = {
                text = "%percentage:3%%";
                warn = "%percentage:3%%";
              };
              warn.percentage = "90";
            };
          }
          {
            name = "module/cpu-fan";
            value = {
              exec =
                if config.nushell.enable then
                  "${config.home.profileDirectory}/bin/nu -c "
                  + "'${pkgs.lm_sensors}/bin/sensors | find fan2 | split row -r `\\s+` | get 1'"
                else
                  "${pkgs.lm_sensors}/bin/sensors | ${pkgs.gnugrep}/bin/grep fan2 "
                  + "| ${pkgs.gawk}/bin/awk '{print $2}'";
            };
          }
          {
            name = "module/cpu-temp";
            value = {
              exec =
                if config.nushell.enable then
                  "${config.home.profileDirectory}/bin/nu -c "
                  + "'${pkgs.lm_sensors}/bin/sensors | find `Package id 0:` | split row -r `\\s+` "
                  + "| get 3 | str replace -a -r `(\\+|\\.\\d)` ``'"
                else
                  "${pkgs.lm_sensors}/bin/sensors | ${pkgs.gnugrep}/bin/grep \"Package id 0:\" "
                  + "| ${pkgs.gawk}/bin/awk '{gsub(/(\\+|\\.[0-9])/, \"\", $4); print $4}'";
            };
          }
        ];
      in
      utils.modulesWithSharedAttrs modules common;
  };
}
