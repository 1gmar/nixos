{
  config,
  lib,
  pkgs,
  ...
}: {
  options.flatpak = {
    enable = lib.mkEnableOption "enable flatpak module";
  };
  config = lib.mkIf config.flatpak.enable {
    services.flatpak = {
      enable = true;
      packages = [
        "org.nickvision.money"
      ];
    };
    xdg.portal = {
      config.common.default = "gtk";
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };
  };
}
