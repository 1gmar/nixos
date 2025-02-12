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
            left.size = "5";
            right.size = "5";
            top.size = "3";
          };
          font = [
            "MesloLGS NF:size=12:style=Bold;3"
            "MesloLGS NF:size=8:style=Bold;3"
            "Material Design Icons:size=18;3"
            "FontAwesome6Free:style=Solid:size=16;3"
          ];
          height = "2.0%";
          module.margin = "1";
          modules.center = "cpu memory disk network";
          modules.right = "tray volume date";
          padding = "1";
          radius = "2";
        };
        "colors" = {
          background = "#fdf6e3";
          backgroundHigh = "#eee8d5";
          blue = "#268bd2";
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
          label.text = "%percentage%%";
          label.warn = "%percentage%%";
          ramp.coreload = {
            background = "\${colors.backgroundHigh}";
            font = "2";
            foreground = "\${colors.blue}";
            spacing = "0";
            text = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          };
          warn.percentage = "90";
        };
        "module/date" = {
          type = "internal/date";
          date = "%Y-%m-%d";
          format = "<label>";
          interval = "1.0";
          label = "%date% %time%";
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
            mounted = "%percentage_used%%";
            warn = {
              foreground = "\${colors.red}";
              text = "%percentage_used%%";
            };
          };
          ramp.capacity = {
            background = "\${colors.backgroundHigh}";
            foreground = "\${colors.blue}";
            text = ["█" "▇" "▆" "▅" "▄" "▃" "▂" "▁"];
          };
          warn.percentage = "90";
        };
        "module/memory" = {
          type = "internal/memory";
          format = {
            prefix = {
              font = "4";
              padding = "0";
              text = "";
            };
            text = "<label> <ramp-used>";
            warn = {
              prefix = {
                font = "4";
                padding-right = "1";
                text = "";
              };
              text = "<label-warn> <ramp-used>";
            };
          };
          interval = "1.0";
          label = {
            text = "%percentage_used%%";
            warn = {
              foreground = "\${colors.red}";
              text = "%percentage_used%%";
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
            connected = "%{T3}󰅀%{T-}%downspeed% %{T3}󰅃%{T-}%upspeed%";
            disconnected = {
              font = "3";
              text = "󰲛";
            };
          };
        };
        "module/tray" = {
          type = "internal/tray";
          format.margin = "1";
          tray.spacing = "1";
        };
        "module/volume" = {
          type = "internal/pulseaudio";
          format.volume = "<ramp-volume> <label-volume>";
          label.muted = {
            foreground = "\${colors.red}";
            text = "%{T3}󰖁%{T-}%percentage%%";
          };
          label.volume = "%percentage%%";
          ramp = {
            font = "3";
            volume = ["󰕿" "󰖀" "󰕾"];
          };
        };
      };
    };
  };
}
