{
  lib,
  config,
  ...
}: {
  options = {
    kitty.enable = lib.mkEnableOption "enable kitty module";
  };
  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "MesloLGS NF";
        size = 14;
      };
      keybindings = {
        "ctrl+alt+d" = "scroll_page_down";
        "ctrl+alt+u" = "scroll_page_up";
        "ctrl+shift+d>ctrl+shift+d" = "scroll_home";
        "ctrl+shift+d>ctrl+shift+f" = "scroll_end";
      };
      settings = {
        enabled_layouts = "splits:split_axis=auto";
        scrollback_lines = 10000;
        tab_bar_style = "powerline";
        tab_powerline_style = "angled";
      };
      themeFile = "Solarized_Light";
    };
  };
}
