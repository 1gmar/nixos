{
  colors,
  config,
  lib,
  pkgs,
  ...
}:
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
      keybindings =
        with lib;
        let
          collectKeys =
            prefix: cmd: i: acc: x:
            let
              s = toString x;
              idx = toString (x - i);
            in
            mergeAttrs acc {
              "${prefix}+${s}" = "${cmd} ${idx}";
            };
          gotoKeysFor =
            prefix: cmd: i:
            foldl' (collectKeys prefix cmd i) { } (range 1 9);
          gotoTabKeys = gotoKeysFor "alt" "goto_tab" 0;
          gotoWinKeys = gotoKeysFor "ctrl+shift" "nth_window" 1;
        in
        mergeAttrsList [
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
            "ctrl+alt+d" = "scroll_page_down";
            "ctrl+alt+u" = "scroll_page_up";
            "ctrl+shift+d>ctrl+shift+d" = "scroll_home";
            "ctrl+shift+d>ctrl+shift+f" = "scroll_end";
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
        active_tab_background = colors.secondaryContent;
        active_tab_foreground = colors.background;
        clear_all_shortcuts = "yes";
        cursor_blink_interval = 0;
        cursor_shape = "block";
        enabled_layouts = "splits:split_axis=auto";
        inactive_tab_background = colors.background;
        inactive_tab_foreground = colors.text;
        scrollback_lines = 10000;
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        tab_powerline_style = "angled";
      };
      shellIntegration.mode = "no-cursor";
      themeFile = "Solarized_Light";
    };
    xsession.windowManager.i3.config.keybindings = lib.mkIf config.i3wm.enable {
      "Mod4+Return" = "exec ${pkgs.kitty}/bin/kitty";
    };
  };
}
