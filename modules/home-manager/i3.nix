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
  config = lib.mkIf config.i3wm.enable {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        bars = [];
        colors = {
          background = "#fdf6e3";
          focused = {
            background = "#fdf6e3";
            border = "#268bd2";
            text = "#657b83";
            indicator = "#859900";
            childBorder = "#268db2";
          };
          focusedInactive = {
            background = "#eee8d5";
            border = "#839496";
            text = "#93a1a1";
            indicator = "#859900";
            childBorder = "#839496";
          };
          placeholder = {
            background = "#eee8d5";
            border = "#839496";
            text = "#93a1a1";
            indicator = "#859900";
            childBorder = "#839496";
          };
          unfocused = {
            background = "#eee8d5";
            border = "#839496";
            text = "#93a1a1";
            indicator = "#859900";
            childBorder = "#839496";
          };
          urgent = {
            background = "#eee8d5";
            border = "#dc322f";
            text = "#dc322f";
            indicator = "#859900";
            childBorder = "#dc322f";
          };
        };
        fonts = lib.mkForce {
          names = ["Fira Sans"];
          size = 8.0;
          style = "Bold";
        };
        gaps = {
          inner = 2;
          outer = 0;
        };
        keybindings = {
          "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";
          "${mod}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
          "${mod}+Shift+c" = "kill";
          "--release button2" = "kill";
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
          "${mod}+f" = "floating toggle";
          "${mod}+Escape" = "exec ${pkgs.systemd}/bin/loginctl lock-session && ${pkgs.coreutils-full}/bin/sleep 5 && ${pkgs.xorg.xset}/bin/xset dpms force off";
          "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl --player=%any play-pause";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl --player=%any next";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl --player=%any previous";
        };
        modifier = mod;
        startup = [
          {
            always = true;
            command = "${pkgs.feh}/bin/feh --bg-fill ${wallpaperPath}";
            notification = false;
          }
          {
            always = true;
            command = "systemctl --user restart polybar.service";
            notification = false;
          }
          {
            always = false;
            command = "${pkgs.ibus}/bin/ibus start";
            notification = false;
          }
          {
            always = false;
            command = "${pkgs.keepassxc}/bin/keepassxc --localconfig ${config.home.homeDirectory}/.config/keepassxc/keepassxc_local.ini";
            notification = false;
          }
          {
            always = false;
            command = "${pkgs.telegram-desktop}/bin/telegram-desktop";
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
