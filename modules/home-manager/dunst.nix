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
          height = 300;
          width = 400;
          corner_radius = 10;
          follow = "mouse";
          font = "Fira Sans 12";
          format = "<b>%s</b>\\n%b";
          frame_width = 2;
          idle_threshold = 120;
          markup = "full";
          notification_limit = 3;
          offset = "(10, 29)";
          origin = "top-right";
          padding = 12;
          progress_bar = true;
          progress_bar_corner_radius = 5;
          progress_bar_height = 10;
          progress_bar_horizontal_alignment = "center";
          progress_bar_frame_width = 1;
          progress_bar_min_width = 150;
          progress_bar_max_width = 400;
          horizontal_padding = 14;
          text_icon_padding = 20;
          transparency = 0;
        };
        urgency_low = {
          background = background;
          foreground = text;
          frame_color = green;
          highlight = "${green},${yellow},${orange},${red}";
          timeout = 5;
        };
        urgency_normal = {
          background = background;
          foreground = text;
          frame_color = yellow;
          highlight = "${green},${yellow},${orange},${red}";
          timeout = 10;
        };
        urgency_critical = {
          background = background;
          foreground = orange;
          frame_color = red;
          highlight = "${green},${yellow},${orange},${red}";
          timeout = 1000;
        };
        volume = {
          appname = "Volume";
          default_icon = "audio-volume-medium-symbolic";
          hide_text = true;
          set_stack_tag = "volume";
          set_transient = "yes";
        };
      };
    };
  };
}
