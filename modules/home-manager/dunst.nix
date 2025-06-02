{
  colors,
  config,
  lib,
  pkgs,
  ...
}: {
  options.dunst = {
    enable = lib.mkEnableOption "enable dunst module";
  };
  config = lib.mkIf config.dunst.enable {
    services.dunst = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = "symbolic";
      };
      settings = with colors; {
        global = {
          corner_radius = 10;
          follow = "mouse";
          font = "Fira Sans 12";
          format = "<b>%s</b>\\n%b";
          frame_width = 2;
          fullscreen = "delay";
          height = 300;
          highlight = "${green},${yellow},${orange},${red}";
          horizontal_padding = 14;
          idle_threshold = "10m";
          markup = "full";
          notification_limit = 3;
          offset = "(5, 27)";
          origin = "top-right";
          padding = 10;
          progress_bar = true;
          progress_bar_corner_radius = 5;
          progress_bar_frame_width = 1;
          progress_bar_height = 10;
          progress_bar_horizontal_alignment = "center";
          progress_bar_max_width = 400;
          progress_bar_min_width = 150;
          show_age_threshold = -1;
          transparency = 0;
          width = 400;
        };
        urgency_low = {
          inherit background;
          foreground = text;
          frame_color = green;
          timeout = 5;
        };
        urgency_normal = {
          inherit background;
          foreground = text;
          frame_color = yellow;
          timeout = 5;
        };
        urgency_critical = {
          inherit background;
          foreground = orange;
          frame_color = red;
          timeout = 1000;
        };
        volume = {
          appname = "Volume";
          default_icon = "audio-volume-high-symbolic";
          hide_text = true;
          set_stack_tag = "volume";
          set_transient = "yes";
          timeout = 2;
        };
      };
    };
  };
}
