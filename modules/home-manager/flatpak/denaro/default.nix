{
  config,
  lib,
  pkgs,
  ...
}:
let
  app-id = "org.nickvision.money";
in
{
  options.denaro = {
    enable = lib.mkEnableOption "enable denaro module";
  };
  config = lib.mkIf config.denaro.enable {
    home.file = {
      ".local/share/fonts/denaro/inter".source = ./fonts;
      ".local/share/fonts/denaro/noto-sans-cjk".source = "${pkgs.noto-fonts-cjk-sans}/share/fonts";
      ".var/app/${app-id}/config/fontconfig".source = ./fontconfig;
    };
    services.flatpak = {
      overrides.${app-id}.Context.filesystems = [
        "/nix/store/:ro"
      ];
      packages = [
        "flathub:app/${app-id}//stable:4bf6d496e6e3d49d8a57a7e783e51fe8ac1b94148ff94eebda1eb7a917383422"
      ];
    };
  };
}
