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
          background = "#fdf6e3";
          foreground = "#657b83";
          border.left.size = "5";
          border.right.size = "5";
          border.top.size = "3";
          font = [
            "MesloLGS NF:size=12:style=Bold;3"
            "Noto Color Emoji:scale=8;2"
            "MesloLGS NF:size=8:style=Bold;3"
            "Material Design Icons:size=12;3"
            "Material Design Icons:size=18;3"
          ];
          height = "2.0%";
          module.margin = "1";
          modules.center = "cpu memory disk";
          modules.right = "volume date";
          padding = "1";
          radius = "2";
        };
        "module/cpu" = {
          type = "internal/cpu";
          format = {
            prefix = {
              font = "5";
              padding = "0";
              text = "󰍛";
            };
            text = "<label> <ramp-coreload>";
            warn = {
              prefix = {
                font = "5";
                padding = "0";
                text = "󰍛";
              };
              text = "%{F#dc322f}%percentage%%%{F-}";
            };
          };
          interval = "0.5";
          label.text = "%percentage%%";
          ramp.coreload = {
            background = "#eee8d5";
            font = "3";
            foreground = "#268bd2";
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
                font = "5";
                padding = "0";
                text = "󰋊";
              };
              text = "<label-mounted> <ramp-capacity>";
            };
            warn = {
              prefix = {
                font = "5";
                padding = "0";
                text = "󰋊";
              };
              text = "<label-warn> <ramp-capacity>";
            };
          };
          interval = "10";
          label = {
            mounted = "%percentage_used%%";
            warn = "%{F#dc322f}%percentage_used%%%{F-}";
          };
          ramp.capacity = {
            background = "#eee8d5";
            foreground = "#268bd2";
            text = ["█" "▇" "▆" "▅" "▄" "▃" "▂" "▁"];
          };
          warn.percentage = "90";
        };
        "module/memory" = {
          type = "internal/memory";
          format = {
            prefix = {
              font = "5";
              padding = "0";
              text = "󰤽";
            };
            text = "<label> <ramp-used>";
            warn = {
              prefix = {
                font = "5";
                padding = "0";
                text = "󰤽";
              };
              text = "<label-warn> <ramp-used>";
            };
          };
          interval = "1.0";
          label.text = "%percentage_used%%";
          label.warn = "%{F#dc322f}%percentage_used%%%{F-}";
          ramp.used = {
            background = "#eee8d5";
            foreground = "#268bd2";
            text = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          };
          warn.percentage = "90";
        };
        "module/volume" = {
          type = "internal/pulseaudio";
          format.volume = "<ramp-volume> <label-volume>";
          label.muted = {
            foreground = "#dc322f";
            text = "%{T5}󰖁%{T-}%percentage%%";
          };
          label.volume = "%percentage%%";
          ramp = {
            font = "5";
            volume = ["󰕿" "󰖀" "󰕾"];
          };
        };
      };
    };
  };
}
