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
      terminal = "${pkgs.kitty}/bin/kitty";
    };
  };
}
