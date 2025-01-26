{
  lib,
  config,
  pkgs,
  wallpaperPath,
  ...
}: let
  mod = "Mod4";
in {
  options = {
    i3wm.enable = lib.mkEnableOption "enable i3wm module";
  };
  config = lib.mkIf config.kitty.enable {
    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
        modifier = mod;
        bars = [];
        gaps = {
          inner = 5;
          outer = 2;
        };
        keybindings = {
          "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";
          "${mod}+d" = "exec --no-startup-id ${pkgs.dmenu}/bin/dmenu";
          "${mod}+Shift+q" = "kill";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+h" = "focus left";
          "${mod}+l" = "focus right";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+l" = "move right";
          "${mod}+z" = "split v";
          "${mod}+x" = "split h";
          "${mod}+m" = "fullscreen toggle";
          "${mod}+s" = "layout tabbed";
          "${mod}+e" = "layout toggle split";
        };
        startup = [
          {
            command = "${pkgs.feh}/bin/feh --bg-fill ${wallpaperPath}";
            always = true;
            notification = false;
          }
        ];
        window = {
          border = 0;
          hideEdgeBorders = "both";
        };
      };
    };
  };
}
