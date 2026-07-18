{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.pointer-cursor = {
    enable = lib.mkEnableOption "enable pointer cursor customisation";
    size = lib.mkOption {
      type = lib.types.int;
      default = 20;
    };
  };
  config = lib.mkIf config.pointer-cursor.enable {
    home.pointerCursor = {
      enable = true;
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = config.pointer-cursor.size;
      x11.enable = true;
    };
  };
}
