{
  colors,
  lib,
  config,
  pkgs,
  wallpaperPath,
  ...
}: let
  mod = "Mod4";
  foldMapDict = acc: x: let
    s = builtins.toString x;
  in
    lib.mergeAttrs acc {
      "${mod}+${s}" = "workspace number ${s}";
      "${mod}+Shift+${s}" = "move window to workspace number ${s}";
    };
  defaultWorkspaceMappings = builtins.foldl' foldMapDict {} (lib.range 1 9);
  workspace = {
    browser = "1: browser";
    email = "2: email";
    messenger = "3: messenger";
    terminal = "4: terminal";
  };
  audioSink = "@DEFAULT_AUDIO_SINK@";
  unmuteCmd = "${pkgs.wireplumber}/bin/wpctl set-mute ${audioSink} 0";
  getVolumeCmd = "${pkgs.wireplumber}/bin/wpctl get-volume ${audioSink} | ${pkgs.gawk}/bin/awk '{if ($3 ~ /MUTED/) print 0; else print 100 * $2}'";
  muteToggleCmd = "${pkgs.wireplumber}/bin/wpctl set-mute ${audioSink} toggle";
  adjustVolumeCmd = sign: "${pkgs.wireplumber}/bin/wpctl set-volume ${audioSink} 5%${sign}";
  sendNotification = volume: "${pkgs.dunst}/bin/dunstify -a Volume -h int:value:$(${volume}) -u low blank";
  volumeCmd = sign: "exec \"${unmuteCmd} && ${adjustVolumeCmd sign} && ${sendNotification getVolumeCmd}\"";
  muteVolumeCmd = "exec \"${muteToggleCmd} && ${sendNotification getVolumeCmd}\"";
  rofi = "${config.home.profileDirectory}/bin/rofi";
in {
  options = {
    i3wm.enable = lib.mkEnableOption "enable i3wm module";
  };
  config = lib.mkIf config.i3wm.enable {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        assigns = {
          ${workspace.browser} = [{class = "librewolf";}];
          ${workspace.email} = [{class = "thunderbird";}];
          ${workspace.messenger} = [{class = "TelegramDesktop";}];
        };
        bars = [];
        colors = with colors; {
          background = background;
          focused = {
            background = background;
            border = blue;
            text = text;
            indicator = green;
            childBorder = blue;
          };
          focusedInactive = {
            background = backgroundHigh;
            border = foreground0;
            text = secondaryContent;
            indicator = green;
            childBorder = foreground0;
          };
          placeholder = {
            background = backgroundHigh;
            border = foreground0;
            text = secondaryContent;
            indicator = green;
            childBorder = foreground0;
          };
          unfocused = {
            background = backgroundHigh;
            border = foreground0;
            text = secondaryContent;
            indicator = green;
            childBorder = foreground0;
          };
          urgent = {
            background = backgroundHigh;
            border = magenta;
            text = red;
            indicator = green;
            childBorder = magenta;
          };
        };
        floating.criteria = [
          {
            class = "librewolf";
            window_role = "About";
          }
          {
            class = "librewolf";
            window_role = "Organizer";
          }
          {class = "Qalculate-gtk";}
          {class = "pavucontrol";}
        ];
        fonts = lib.mkForce {
          names = ["Fira Sans"];
          size = 0.0;
          style = "Bold";
        };
        gaps = {
          inner = 2;
          outer = 0;
        };
        keybindings = lib.mergeAttrs defaultWorkspaceMappings {
          "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";
          "${mod}+d" = "exec ${rofi} -show drun";
          "${mod}+Shift+d" = "exec ${rofi} -font \"Fira Mono 14\" -show calc -no-show-match -no-sort";
          "${mod}+Shift+p" = "exec \"${rofi} -show power-menu -theme-str 'window {width: 8em;} listview {lines: 6;}'\"";
          "${mod}+c" = "kill";
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
          "${mod}+r" = "mode resize";
          "${mod}+Escape" = "exec ${pkgs.ibus-with-plugins}/bin/ibus engine xkb:us::eng && ${pkgs.systemd}/bin/loginctl lock-session && ${pkgs.coreutils-full}/bin/sleep 3 && ${pkgs.xorg.xset}/bin/xset dpms force off";
          "${mod}+Shift+z" = "workspace ${workspace.browser}";
          "${mod}+Shift+x" = "workspace ${workspace.email}";
          "${mod}+Shift+c" = "workspace ${workspace.messenger}";
          "${mod}+Shift+comma" = "workspace ${workspace.terminal}";
          "Mod1+Tab" = "workspace next";
          "Mod1+Shift+Tab" = "workspace prev";
          "Mod1+backslash" = "workspace back_and_forth";
          "XF86AudioLowerVolume" = volumeCmd "-";
          "XF86AudioMute" = muteVolumeCmd;
          "XF86AudioRaiseVolume" = volumeCmd "+";
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl --player=%any play-pause";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl --player=%any next";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl --player=%any previous";
        };
        modes.resize = {
          "h" = "resize grow width 5 px or 5 ppt";
          "j" = "resize shrink height 5 px or 5 ppt";
          "k" = "resize grow height 5 px or 5 ppt";
          "l" = "resize shrink width 5 px or 5 ppt";
          "Return" = "mode default";
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
            command = "${pkgs.crow-translate}/bin/crow";
            notification = false;
          }
          {
            always = false;
            command = "${pkgs.telegram-desktop}/bin/telegram-desktop";
            notification = false;
          }
          {
            always = false;
            command = "${pkgs.thunderbird}/bin/thunderbird";
            notification = false;
          }
          {
            always = false;
            command = "${pkgs.i3}/bin/i3-msg 'workspace ${workspace.browser}; exec --no-startup-id ${pkgs.librewolf}/bin/librewolf'";
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
