{
  colors,
  config,
  lib,
  pkgs,
  ...
}: {
  options.cpu = {
    enable = lib.mkEnableOption "enable polybar cpu module";
  };
  config = lib.mkIf config.cpu.enable {
    polybar.centerModules = lib.mkOrder 1040 ["cpu" "cpu-fan" "cpu-temp"];
    services.polybar.settings = {
      "module/cpu" = {
        type = "internal/cpu";
        format = {
          foreground = colors.blue;
          prefix = {
            font = "2";
            text = "󰍛";
          };
          text = "<label>";
          warn = {
            foreground = colors.red;
            prefix = {
              font = "2";
              text = "󰍛";
            };
            text = "<label-warn>";
          };
        };
        interval = "0.5";
        label.text = "%percentage:2%%";
        label.warn = "%percentage:2%%";
        warn.percentage = "90";
      };
      "module/cpu-fan" = {
        type = "custom/script";
        exec =
          if config.nushell.enable
          then
            "${config.home.profileDirectory}/bin/nu -c "
            + "'${pkgs.lm_sensors}/bin/sensors | find fan2 | split row -r `\\s+` | get 1'"
          else
            "${pkgs.lm_sensors}/bin/sensors | ${pkgs.gnugrep}/bin/grep fan2 "
            + "| ${pkgs.gawk}/bin/awk '{print $2}'";
        format = {
          foreground = colors.blue;
          text = "<label>";
        };
        interval = "0.5";
        label = "%output:4%";
      };
      "module/cpu-temp" = {
        type = "custom/script";
        exec =
          if config.nushell.enable
          then
            "${config.home.profileDirectory}/bin/nu -c "
            + "'${pkgs.lm_sensors}/bin/sensors | find `Package id 0:` | split row -r `\\s+` "
            + "| get 3 | str replace -a -r `(\\+|\\.\\d)` ``'"
          else
            "${pkgs.lm_sensors}/bin/sensors | ${pkgs.gnugrep}/bin/grep \"Package id 0:\" "
            + "| ${pkgs.gawk}/bin/awk '{gsub(/(\\+|\\.[0-9])/, \"\", $4); print $4}'";
        format = {
          foreground = colors.blue;
          text = "<label>";
        };
        interval = "0.5";
        label = "%output:4%";
      };
    };
  };
}
