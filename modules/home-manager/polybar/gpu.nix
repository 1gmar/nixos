{
  colors,
  config,
  lib,
  pkgs,
  ...
}: {
  options.gpu = {
    enable = lib.mkEnableOption "enable polybar gpu module";
  };
  config = lib.mkIf config.gpu.enable {
    polybar.centerModules = lib.mkOrder 1060 ["gpu" "gpu-fan" "gpu-temp"];
    services.polybar.settings = {
      "module/gpu" = {
        type = "custom/script";
        exec =
          "/run/current-system/sw/bin/nvidia-smi --query-gpu=utilization.gpu "
          + "--format=csv,noheader,nounits";
        format = {
          fail = "<label-fail>";
          foreground = colors.green;
          prefix = {
            font = "2";
            padding.right = "5px";
            text = "󰢮";
          };
          text = "<label>";
        };
        interval = {
          fail = "6000";
          text = "0.5";
        };
        label = {
          fail = {
            font = "2";
            foreground = colors.red;
            text = "󱄋";
          };
          text = "%output:2%%";
        };
      };
      "module/gpu-fan" = {
        type = "custom/script";
        exec =
          if config.nushell.enable
          then
            "${config.home.profileDirectory}/bin/nu -c "
            + "'${pkgs.lm_sensors}/bin/sensors | find fan1 | split row -r `\\s+` | get 1'"
          else
            "(set -o pipefail && ${pkgs.lm_sensors}/bin/sensors "
            + "| ${pkgs.gnugrep}/bin/grep fan1 | ${pkgs.gawk}/bin/awk '{print $2}')";
        format = {
          fail = "<label-fail>";
          foreground = colors.green;
          text = "<label>";
        };
        interval = {
          fail = "6000";
          text = "0.5";
        };
        label = {
          fail = {
            font = "2";
            foreground = colors.red;
            text = "󱄋";
          };
          text = "%output:4%";
        };
      };
      "module/gpu-temp" = {
        type = "custom/script";
        exec =
          "/run/current-system/sw/bin/nvidia-smi --query-gpu=temperature.gpu "
          + "--format=csv,noheader,nounits";
        format = {
          fail = "<label-fail>";
          foreground = colors.green;
          text = "<label>";
        };
        interval = {
          fail = "6000";
          text = "0.5";
        };
        label = {
          fail = {
            font = "2";
            foreground = colors.red;
            text = "󱄋";
          };
          text = "%output:2%°C";
        };
      };
    };
  };
}
