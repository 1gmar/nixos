{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.stylix-mode;
in {
  options.stylix-mode = {
    enable = lib.mkEnableOption "enable stylix module";
    wallpaper = lib.mkOption {
      description = "wallpaper path";
    };
  };
  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = false;
      image = "${cfg.wallpaper}";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
      fonts = {
        monospace = {
          name = lib.mkDefault "JetBrainsMono";
        };
        sansSerif = {
          name = "DejaVu Sans";
        };
        serif = {
          name = "DejaVu Serif";
        };
      };
    };
  };
}
