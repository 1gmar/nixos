{
  colors,
  config,
  lib,
  pkgs,
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
in {
  options.i3wm = {
    enable = lib.mkEnableOption "enable i3wm module";
  };
  config = lib.mkIf config.i3wm.enable {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        assigns = {
          ${workspace.browser} = [{class = "firefox";}];
          ${workspace.email} = [{class = "thunderbird";}];
          ${workspace.messenger} = [{class = "TelegramDesktop";}];
        };
        bars = [];
        colors = with colors; {
          inherit background;
          focused = {
            inherit background;
            border = blue;
            inherit text;
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
            class = "firefox";
            window_role = "About";
          }
          {
            class = "firefox";
            window_role = "Organizer";
          }
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
          {class = ".protonvpn-app-wrapped";}
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
          "${mod}+i" = "workspace ${workspace.browser}";
          "${mod}+o" = "workspace ${workspace.email}";
          "${mod}+p" = "workspace ${workspace.messenger}";
          "${mod}+bracketleft" = "workspace ${workspace.terminal}";
          "Mod1+backslash" = "workspace back_and_forth";
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
            always = false;
            command = "${pkgs.telegram-desktop}/bin/Telegram";
            notification = false;
          }
          {
            always = false;
            command = "${config.home.profileDirectory}/bin/i3-msg 'workspace ${workspace.browser}'";
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
