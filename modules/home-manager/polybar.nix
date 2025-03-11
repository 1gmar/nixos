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
            "Material Design Icons:size=18;4"
            "Noto Sans CJK JP:size=12:style=Bold;3"
            "MesloLGS NF:size=18:style=Bold;3"
          ];
          height = "2.0%";
          module.margin = "5px";
          modules = {
            center = "cpu cpu-fan cpu-temp network";
            left = "gpu gpu-fan gpu-temp memory disk";
            right = "tray weather volume input-method date time";
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
              font = "2";
              text = "󰍛";
            };
            text = "<label> <ramp-coreload>";
            warn = {
              prefix = {
                font = "2";
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
            "7".foreground = "\${colors.red}";
            background = "\${colors.backgroundHigh}";
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
              font = "2";
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
            font = "2";
            text = "󰔏";
          };
          hwmon.path = "/sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input";
          thermal.zone = "0";
          zone.type = "x86_pkg_temp";
        };
        "module/date" = {
          type = "custom/script";
          exec = "${pkgs.coreutils-full}/bin/date +%Y年%-m月%-e日";
          format = {
            prefix = {
              font = "2";
              text = "󰸗";
            };
            text = "<label>";
          };
          interval = "1";
          label = "%output%";
        };
        "module/time" = {
          type = "custom/script";
          exec = "${pkgs.coreutils-full}/bin/date +%H:%M:%S";
          format = {
            prefix = {
              font = "2";
              text = "󰅐";
            };
            text = "<label>";
          };
          interval = "1";
          label = "%output%";
        };
        "module/disk" = {
          type = "internal/fs";
          format = {
            mounted = {
              prefix = {
                font = "2";
                text = "󰋊";
              };
              text = "<label-mounted>";
            };
            warn = {
              prefix = {
                font = "2";
                text = "󰋊";
              };
              text = "<label-warn>";
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
          warn.percentage = "90";
        };
        "module/gpu" = {
          type = "custom/script";
          exec = "/run/current-system/sw/bin/nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits";
          format = {
            prefix = {
              font = "2";
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
              font = "2";
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
              font = "2";
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
              font = "2";
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
              font = "2";
              padding.right = "5px";
              text = "󰘚";
            };
            text = "<label>";
            warn = {
              prefix = {
                font = "2";
                padding.right = "5px";
                text = "󰘚";
              };
              text = "<label-warn>";
            };
          };
          interval = "1";
          label = {
            text = "%percentage_used:2%%";
            warn = {
              foreground = "\${colors.red}";
              text = "%percentage_used:2%%";
            };
          };
          warn.percentage = "90";
        };
        "module/network" = {
          type = "internal/network";
          format.connected = {
            prefix = {
              font = "2";
              text = "󰛳";
            };
            text = "<label-connected>";
          };
          format.disconnected = "<label-disconnected>";
          interface = "enp5s0";
          interval = "0.5";
          label = {
            connected = "%downspeed:10%%{F#268bd2}%{T2}󰜮%{F- T-} %upspeed:10%%{F#859900}%{T2}󰜷%{F- T-}";
            disconnected = {
              font = "2";
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
            text = "%{T2}󰖁%{T-} %percentage:2%%";
          };
          label.volume = "%percentage:2%%";
          ramp.volume = {
            font = "2";
            text = ["󰕿" "󰖀" "󰕾"];
          };
        };
        "module/weather" = {
          type = "custom/script";
          exec = "(set -o pipefail && ${pkgs.wthrr}/bin/wthrr | ${pkgs.gawk}/bin/awk 'NR==4 {split($0, L, \",\"); split(L[2], S, \" \"); print $2, S[1]}')";
          format = {
            fail = "<label-fail>";
            text = "<label>";
          };
          interval = {
            fail = "5";
            text = "300";
          };
          label = {
            fail = {
              font = "2";
              foreground = "\${colors.red}";
              text = "󱯻 󰲛";
            };
            text = "%output:8%";
          };
        };
      };
    };
  };
}
