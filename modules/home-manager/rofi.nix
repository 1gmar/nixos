{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    rofi.enable = lib.mkEnableOption "enable rofi module";
  };
  config = lib.mkIf config.rofi.enable {
    programs.rofi = {
      enable = true;
      extraConfig = {
        modes = "window,drun,run,ssh,calc,power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
      };
      font = "Fira Sans 14";
      plugins = with pkgs; [rofi-calc rofi-power-menu];
      terminal = "${pkgs.kitty}/bin/kitty";
    };
  };
}
