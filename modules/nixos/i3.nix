{
  colors,
  config,
  lib,
  userName,
  ...
}:
let
  mod = "Mod4";
  keyMap =
    x:
    let
      s = toString x;
    in
    [
      "bindsym ${mod}+${s} workspace number ${s}"
      "bindsym ${mod}+Shift+${s} move window to workspace number ${s}"
    ];
  defaultWorkspaceMappings = lib.concatMap keyMap (lib.range 1 9);
  cfg = config.i3;
  hmCfg = config.home-manager.users.${userName};
  i3Config = with colors; ''
    font pango:Fira Sans Bold 8.000000
    floating_modifier ${mod}
    default_border pixel 5
    default_floating_border pixel 5
    hide_edge_borders smart
    focus_wrapping yes
    focus_follows_mouse yes
    focus_on_window_activation smart
    mouse_warping output
    workspace_layout default
    workspace_auto_back_and_forth no

    # colors
    client.focused ${cyan} ${background} ${primaryContent} ${green} ${cyan}
    client.focused_inactive ${brightBlue} ${backHighlight} ${secondaryContent} ${green} ${brightBlue}
    client.unfocused ${backHighlight} ${backHighlight} ${secondaryContent} ${green} ${backHighlight}
    client.urgent ${magenta} ${backHighlight} ${red} ${green} ${magenta}
    client.placeholder ${brightBlue} ${backHighlight} ${secondaryContent} ${green} ${brightBlue}
    client.background ${background}

    # keybindings
    # default workspace
    bindsym ${mod}+i workspace ${cfg.workspaces.browser}
    bindsym ${mod}+o workspace ${cfg.workspaces.email}
    bindsym ${mod}+p workspace ${cfg.workspaces.messenger}
    bindsym ${mod}+bracketleft workspace ${cfg.workspaces.terminal}
    bindsym --release button2 kill
    bindsym Mod1+backslash workspace back_and_forth
    bindsym ${mod}+Shift+h move left
    bindsym ${mod}+Shift+j move down
    bindsym ${mod}+Shift+k move up
    bindsym ${mod}+Shift+l move right
    bindsym ${mod}+c kill
    bindsym ${mod}+e layout toggle split
    bindsym ${mod}+f floating toggle
    bindsym ${mod}+h focus left
    bindsym ${mod}+j focus down
    bindsym ${mod}+k focus up
    bindsym ${mod}+l focus right
    bindsym ${mod}+m fullscreen toggle
    bindsym ${mod}+r mode resize
    bindsym ${mod}+s layout tabbed
    bindsym ${mod}+x split h
    bindsym ${mod}+z split v
    ${lib.concatStringsSep "\n" defaultWorkspaceMappings}

    mode "resize" {
      bindsym Return mode default
      bindsym h resize grow width 5 px or 5 ppt
      bindsym j resize shrink height 5 px or 5 ppt
      bindsym k resize grow height 5 px or 5 ppt
      bindsym l resize shrink width 5 px or 5 ppt
    }

    gaps inner 5
    gaps outer 0
    smart_gaps on

    for_window [class="Qalculate-gtk"] floating enable
    for_window [class="pavucontrol"] floating enable
    for_window [class=".protonvpn-app-wrapped"] floating enable
  '';
in
{
  options.i3 = with lib.types; {
    enable = lib.mkEnableOption "enable i3 window manager";
    extraConfig = lib.mkOption {
      type = lines;
      default = "";
    };
    workspaces = lib.mkOption {
      type = attrsOf str;
      default = {
        browser = "1: browser";
        email = "2: email";
        messenger = "3: messenger";
        terminal = "4: terminal";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !hmCfg.xsession.windowManager.i3.enable;
        description = "Configuration file conflict.";
      }
    ];
    home-manager.users.${userName}.xdg.configFile."i3/config".text = lib.mkMerge [
      i3Config
      cfg.extraConfig
      hmCfg.i3.extraConfig
    ];
    services.xserver.windowManager.i3 = {
      enable = true;
      extraPackages = [ ];
    };
  };
}
