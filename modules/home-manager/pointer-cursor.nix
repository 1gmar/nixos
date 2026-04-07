{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.pointer-cursor = {
    enable = lib.mkEnableOption "enable pointer cursor customisation";
  };
  config = lib.mkIf config.pointer-cursor.enable {
    home.pointerCursor = {
      enable = true;
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 20;
      x11.enable = true;
    };
  };
}
