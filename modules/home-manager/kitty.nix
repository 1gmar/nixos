{
  colors,
  config,
  lib,
  pkgs,
  ...
}:
let
  collectKeys =
    with lib;
    prefix: cmd: i: acc: x:
    let
      s = toString x;
      idx = toString (x - i);
    in
    mergeAttrs acc {
      "${prefix}+${s}" = "${cmd} ${idx}";
    };
  gotoKeysFor =
    with lib;
    prefix: cmd: i:
    foldl' (collectKeys prefix cmd i) { } (range 1 9);
  gotoTabKeys = gotoKeysFor "alt" "goto_tab" 0;
  gotoWinKeys = gotoKeysFor "ctrl+shift" "nth_window" 1;
in
{
  options.kitty = {
    enable = lib.mkEnableOption "enable kitty module";
  };
  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono NF";
        size = 14;
      };
      extraConfig = lib.mkBefore ''
        include ${config.xdg.configHome}/kitty/themes/Solarized_Light.conf
      '';
      keybindings = lib.mergeAttrsList [
        gotoTabKeys
        gotoWinKeys
        {
          # Copy/paste
          "ctrl+shift+c" = "copy_to_clipboard";
          "ctrl+shift+v" = "paste_from_clipboard";
          "ctrl+shift+g" = "show_last_command_output";
          #Miscellaneous
          "ctrl+shift+l" = "clear_terminal reset active";
          # Scrolling
          "ctrl+shift+j" = "scroll_line_down";
          "ctrl+shift+k" = "scroll_line_up";
          "ctrl+alt+d" = "scroll_end";
          "ctrl+alt+u" = "scroll_home";
          "ctrl+shift+d" = "scroll_page_down";
          "ctrl+shift+u" = "scroll_page_up";
          # Tab management
          "ctrl+shift+t" = "new_tab";
          "ctrl+tab" = "next_tab";
          "ctrl+shift+tab" = "previous_tab";
          # Window management
          "ctrl+shift+enter" = "new_window";
          "ctrl+shift+]" = "next_window";
          "ctrl+shift+[" = "previous_window";
          "ctrl+shift+w" = "close_window";
          "alt+h" = "launch --location=hsplit";
          "alt+v" = "launch --location=vsplit";
        }
      ];
      settings = {
        clear_all_shortcuts = "yes";
        cursor_blink_interval = 0;
        cursor_shape = "block";
        enabled_layouts = "splits:split_axis=auto";
        scrollback_lines = 10000;
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        tab_powerline_style = "angled";
      };
      shellIntegration.mode = "no-cursor";
    };
    xdg.configFile."kitty/themes/Solarized_Light.conf".text = with colors; ''
      ## name: Solarized Light
      ## author: Ethan Schoonover
      ## license: MIT
      ## blurb: Precision colors for machines and people

      # The basic colors
      foreground              ${primaryContent}
      background              ${background}
      selection_foreground    ${highlight}
      selection_background    ${backHighlight}

      # Cursor colors
      cursor                  ${primaryContent}
      cursor_text_color       ${background}

      # kitty window border colors
      active_border_color     ${orange}
      inactive_border_color   ${secondaryContent}

      # Tab bar colors
      active_tab_background   ${secondaryContent}
      active_tab_foreground   ${background}
      inactive_tab_background ${background}
      inactive_tab_foreground ${primaryContent}

      # The basic 16 colors
      # black
      color0 ${black}
      color8 ${brightBlack}

      # red
      color1 ${red}
      color9 ${orange}

      # green
      color2  ${green}
      color10 ${highlight}

      # yellow
      color3  ${yellow}
      color11 ${primaryContent}

      # blue
      color4  ${blue}
      color12 ${brightBlue}

      # magenta
      color5  ${magenta}
      color13 ${violet}

      # cyan
      color6  ${cyan}
      color14 ${secondaryContent}

      # white
      color7  ${backHighlight}
      color15 ${background}
    '';
    i3.extraConfig = ''
      bindsym Mod4+Return exec --no-startup-id ${config.home.profileDirectory}/bin/kitty
    '';
    xsession.windowManager.i3.config.keybindings = {
      "Mod4+Return" = "exec ${pkgs.kitty}/bin/kitty";
    };
  };
}
