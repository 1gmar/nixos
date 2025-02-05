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
          ];
          height = "2.0%";
          module.margin = "1";
          modules.center = "cpu";
          modules.right = "volume date";
          padding = "1";
          radius = "2";
        };
        "module/cpu" = {
          type = "internal/cpu";
          interval = "0.5";
          warn.percentage = "95";
          format.text = "<label> %{T3}<ramp-coreload>%{T-}";
          label.text = "﬘ %percentage%%";
          format.warn = "﬘ %{F#dc322f}%percentage%%%{F-}";
          ramp.coreload = {
            background = "#eee8d5";
            spacing = "0";
            text = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          };
        };
        "module/date" = {
          type = "internal/date";
          date = "%Y-%m-%d";
          format = "<label>";
          interval = "1.0";
          label = "%date% %time%";
          time = "%H:%M:%S";
        };
        "module/volume" = {
          type = "internal/pulseaudio";
          format.volume = "<ramp-volume> <label-volume>";
          label.muted.foreground = "#dc322f";
          label.muted.text = "婢 %percentage%%";
          label.volume = "%percentage%%";
          ramp.volume = ["奄" "奔" "墳"];
        };
      };
    };
  };
}
