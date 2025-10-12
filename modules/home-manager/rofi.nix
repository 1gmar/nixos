{
  config,
  lib,
  pkgs,
  ...
}: {
  options.rofi = {
    enable = lib.mkEnableOption "enable rofi module";
  };
  config = lib.mkIf config.rofi.enable {
    programs.rofi = {
      enable = true;
      font = "Fira Sans 14";
      modes = [
        "calc"
        "drun"
        {
          name = "power-menu";
          path = lib.getExe pkgs.rofi-power-menu;
        }
        "window"
      ];
      plugins = with pkgs; [rofi-calc];
      terminal = lib.mkIf config.kitty.enable "${pkgs.kitty}/bin/kitty";
    };
    xsession.windowManager.i3.config.keybindings = lib.mkIf config.i3wm.enable (
      let
        mod = "Mod4";
        rofi = "${config.home.profileDirectory}/bin/rofi";
      in {
        "Mod1+Tab" = "exec ${rofi} -show window";
        "${mod}+d" = "exec ${rofi} -show drun";
        "${mod}+Shift+d" = "exec ${rofi} -font \"Fira Mono 14\" -show calc -no-show-match -no-sort -no-history";
        "${mod}+Shift+p" = "exec \"${rofi} -show power-menu -theme-str 'window {width: 8em;} listview {lines: 6;}'\"";
      }
    );
  };
}
