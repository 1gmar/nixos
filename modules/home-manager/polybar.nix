{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    polybar.enable = lib.mkEnableOption "enable polybar module";
  };
  config = lib.mkIf config.polybar.enable {
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
        i3Support = true;
        nlSupport = true;
        pulseSupport = true;
      };
      script = "polybar &";
      settings = {
        "bar/i3-bar" = {
          background = "\${colors.background}";
          foreground = "\${colors.text}";
          border = {
            left.size = "0";
            right.size = "0";
            top.size = "0";
          };
          font = [
            "JetBrainsMono:size=12:style=Bold;3"
            "JetBrainsMono:size=8:style=Bold;3"
            "Material Design Icons:size=18;4"
            "Noto Sans CJK JP:size=12:style=Bold;3"
          ];
          height = "2.0%";
          module.margin = "5px";
          modules = {
            center = "cpu memory disk network";
            left = "gpu gpu-fan gpu-temp cpu-fan cpu-temp";
            right = "tray volume input-method date";
          };
          padding = "1";
          radius = "1";
        };
        "colors" = {
          background = "#fdf6e3";
          backgroundHigh = "#eee8d5";
          blue = "#268bd2";
          green = "#859900";
          red = "#dc322f";
          text = "#657b83";
        };
        "module/cpu" = {
          type = "internal/cpu";
          format = {
            prefix = {
              font = "3";
              padding = "0";
              text = "󰍛";
            };
            text = "<label> <ramp-coreload>";
            warn = {
              prefix = {
                font = "3";
                padding = "0";
                text = "󰍛";
              };
              foreground = "\${colors.red}";
              text = "<label-warn> <ramp-coreload>";
            };
          };
          interval = "0.5";
          label.text = "%percentage:2%%";
          label.warn = "%percentage:2%%";
          ramp.coreload = {
            background = "\${colors.backgroundHigh}";
            font = "2";
            foreground = "\${colors.blue}";
            spacing = "0";
            text = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          };
          warn.percentage = "90";
        };
        "module/cpu-fan" = {
          type = "custom/script";
          exec = "${pkgs.lm_sensors}/bin/sensors | ${pkgs.gnugrep}/bin/grep fan2 | ${pkgs.gawk}/bin/awk '{print $2}'";
          format = {
            prefix = {
              font = "3";
              text = "󰈐";
            };
            text = "<label>";
          };
          interval = "0.5";
          label = "%output:4%";
        };
        "module/cpu-temp" = {
          type = "internal/temperature";
          format.prefix = {
            font = "3";
            text = "󰔏";
          };
          hwmon.path = "/sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input";
          thermal.zone = "0";
          zone.type = "x86_pkg_temp";
        };
        "module/date" = {
          type = "internal/date";
          date = "%Y年%m月%e日";
          format = "<label>";
          interval = "1.0";
          label = "%{T3}󰸗%{T-}%date% %{T3}󰅐%{T-}%time%";
          time = "%H:%M:%S";
        };
        "module/disk" = {
          type = "internal/fs";
          format = {
            mounted = {
              prefix = {
                font = "3";
                padding = "0";
                text = "󰋊";
              };
              text = "<label-mounted> <ramp-capacity>";
            };
            warn = {
              prefix = {
                font = "3";
                padding = "0";
                text = "󰋊";
              };
              text = "<label-warn> <ramp-capacity>";
            };
          };
          interval = "10";
          label = {
            mounted = "%percentage_used:2%%";
            warn = {
              foreground = "\${colors.red}";
              text = "%percentage_used:2%%";
            };
          };
          ramp.capacity = {
            background = "\${colors.backgroundHigh}";
            foreground = "\${colors.blue}";
            text = ["█" "▇" "▆" "▅" "▄" "▃" "▂" "▁"];
          };
          warn.percentage = "90";
        };
        "module/gpu" = {
          type = "custom/script";
          exec = "/run/current-system/sw/bin/nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits";
          format = {
            prefix = {
              font = "3";
              padding.right = "5px";
              text = "󰢮";
            };
            text = "<label>";
          };
          interval = "0.5";
          label = "%output:2%%";
        };
        "module/gpu-fan" = {
          type = "custom/script";
          exec = "${pkgs.lm_sensors}/bin/sensors | ${pkgs.gnugrep}/bin/grep fan1 | ${pkgs.gawk}/bin/awk '{print $2}'";
          format = {
            prefix = {
              font = "3";
              text = "󰈐";
            };
            text = "<label>";
          };
          interval = "0.5";
          label = "%output:4%";
        };
        "module/gpu-temp" = {
          type = "custom/script";
          exec = "/run/current-system/sw/bin/nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits";
          format = {
            prefix = {
              font = "3";
              padding = "0";
              text = "󰔏";
            };
            text = "<label>";
          };
          interval = "0.5";
          label = "%output:2%°C";
        };
        "module/input-method" = {
          type = "internal/xkeyboard";
          format = {
            prefix = {
              font = "3";
              text = "󰖟";
            };
            text = "<label-layout>";
          };
          label.layout = "%icon%";
          layout.icon = {
            default = "en";
            text = ["us;en" "ro;ro" "ru;ru"];
          };
        };
        "module/memory" = {
          type = "internal/memory";
          format = {
            prefix = {
              font = "3";
              padding.right = "5px";
              text = "󰘚";
            };
            text = "<label> <ramp-used>";
            warn = {
              prefix = {
                font = "3";
                padding.right = "5px";
                text = "󰘚";
              };
              text = "<label-warn> <ramp-used>";
            };
          };
          interval = "1.0";
          label = {
            text = "%percentage_used:2%%";
            warn = {
              foreground = "\${colors.red}";
              text = "%percentage_used:2%%";
            };
          };
          ramp.used = {
            background = "\${colors.backgroundHigh}";
            foreground = "\${colors.blue}";
            text = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          };
          warn.percentage = "90";
        };
        "module/network" = {
          type = "internal/network";
          format.connected = "<label-connected>";
          format.disconnected = "<label-disconnected>";
          interface = "enp5s0";
          interval = "0.5";
          label = {
            connected = "%{F#268bd2}%{T3}󰜮%{F- T-}%downspeed:8% %{F#859900}%{T3}󰜷%{F- T-}%upspeed:8%";
            disconnected = {
              font = "3";
              text = "󰲛";
            };
          };
        };
        "module/tray" = {
          type = "internal/tray";
          format.margin = "1";
          tray = {
            size = "70%";
            spacing = "2";
          };
        };
        "module/volume" = {
          type = "internal/pulseaudio";
          format.volume = "<ramp-volume> <label-volume>";
          label.muted = {
            foreground = "\${colors.red}";
            text = "%{T3}󰖁%{T-} %percentage:2%%";
          };
          label.volume = "%percentage:2%%";
          ramp.volume = {
            font = "3";
            text = ["󰕿" "󰖀" "󰕾"];
          };
        };
      };
    };
  };
}
