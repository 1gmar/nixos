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
        let
          collectKeys =
            acc: x:
            let
              s = builtins.toString x;
            in
            lib.mergeAttrs acc {
              "alt+${s}" = "goto_tab ${s}";
            };
          gotoTabKeys = builtins.foldl' collectKeys { } (lib.range 1 9);
        in
        lib.mergeAttrs gotoTabKeys {
          "ctrl+alt+d" = "scroll_page_down";
          "ctrl+alt+u" = "scroll_page_up";
          "ctrl+shift+d>ctrl+shift+d" = "scroll_home";
          "ctrl+shift+d>ctrl+shift+f" = "scroll_end";
          "alt+h" = "launch --location=hsplit";
          "alt+v" = "launch --location=vsplit";
        };
      settings = {
        active_tab_foreground = colors.background;
        active_tab_background = colors.secondaryContent;
        inactive_tab_foreground = colors.text;
        inactive_tab_background = colors.background;
        cursor_blink_interval = 0;
        cursor_shape = "block";
        enabled_layouts = "splits:split_axis=auto";
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
