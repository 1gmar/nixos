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
  options.polybar.gpu = {
    enable = lib.mkEnableOption "enable polybar gpu module";
  };
  config = lib.mkIf config.polybar.gpu.enable {
    polybar = {
      centerModules = lib.mkOrder 1060 [
        "gpu"
        "gpu-fan"
        "gpu-temp"
      ];
      rightModules = lib.mkOrder 1045 [ "gpu-memory" ];
    };
    services.polybar.settings =
      let
        common = {
          type = "custom/script";
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
              font = 2;
              foreground = colors.red;
              text = "󱄋";
            };
          };
        };
        modules = [
          {
            name = "module/gpu";
            value = {
              exec =
                if config.nushell.enable then
                  "${config.home.profileDirectory}/bin/nu -c "
                  + "'/run/current-system/sw/bin/nvidia-smi --query-gpu=utilization.gpu,utilization.encoder,utilization.decoder "
                  + "--format=csv,noheader,nounits | split row `,` | each { str trim | fill -a right -c ` ` -w 3 } "
                  + "| zip [`` `E` `D`] | each { reverse | str join } | update 0 { $in + `%` } | str join ` `'"
                else
                  "/run/current-system/sw/bin/nvidia-smi --query-gpu=utilization.gpu "
                  + "--format=csv,noheader,nounits";
              format.prefix = {
                font = 2;
                padding.right = "5px";
                text = "󰢮";
              };
              label.text = "%output:14%";
            };
          }
          {
            name = "module/gpu-fan";
            value = {
              exec =
                if config.nushell.enable then
                  "${config.home.profileDirectory}/bin/nu -c "
                  + "'/run/current-system/sw/bin/nvidia-settings -q GPUCurrentFanSpeedRPM "
                  + "| lines | get 1 | split row -r `\\s+` | get 4 | str substring 0..-2'"
                else
                  "(set -o pipefail && ${pkgs.lm_sensors}/bin/sensors "
                  + "| ${pkgs.gnugrep}/bin/grep fan1 | ${pkgs.gawk}/bin/awk '{print $2}')";
              label.text = "%output:4%";
            };
          }
          {
            name = "module/gpu-temp";
            value = {
              exec =
                "/run/current-system/sw/bin/nvidia-smi --query-gpu=temperature.gpu "
                + "--format=csv,noheader,nounits";
              label.text = "%output:2%°C";
            };
          }
          {
            name = "module/gpu-memory";
            value = {
              exec =
                if config.nushell.enable then
                  "${config.home.profileDirectory}/bin/nu -c "
                  + "'/run/current-system/sw/bin/nvidia-smi --query-gpu=memory.total,memory.used "
                  + "--format=csv,noheader | split row `,` | into filesize | $in.1 / $in.0 * 100 | math round'"
                else
                  "/run/current-system/sw/bin/nvidia-smi --query-gpu=utilization.memory "
                  + "--format=csv,noheader,nounits";
              format = {
                foreground = colors.violet;
                prefix = {
                  font = 2;
                  padding.right = "5px";
                  text = "󰢮";
                };
              };
              interval.text = "1";
              label.text = "%output:2%%";
            };
          }
        ];
      in
      utils.modulesWithSharedAttrs modules common;
  };
}
