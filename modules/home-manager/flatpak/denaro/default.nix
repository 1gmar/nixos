{
  config,
  lib,
  pkgs,
  ...
}: let
  app-id = "org.nickvision.money";
in {
  options.denaro = {
    enable = lib.mkEnableOption "enable denaro module";
  };
  config = lib.mkIf config.denaro.enable {
    home.file = {
      ".local/share/fonts/denaro/inter" = {
        recursive = true;
        source = ./fonts;
      };
      ".local/share/fonts/denaro/noto-sans-cjk".source = "${pkgs.noto-fonts-cjk-sans}/share/fonts";
      ".var/app/${app-id}/config/fontconfig" = {
        recursive = true;
        source = ./fontconfig;
      };
    };
    services.flatpak = {
      overrides.${app-id}.filesystems = [
        "/nix/store/:ro"
      ];
      packages = [
        "flathub:app/${app-id}//stable"
      ];
    };
  };
}
