{
  config,
  lib,
  pkgs,
  ...
}:
let
  app-id = "com.github.geigi.cozy";
in
{
  options.cozy = {
    enable = lib.mkEnableOption "enable cozy module";
  };
  config = lib.mkIf config.cozy.enable {
    home.file = {
      ".local/share/fonts/cozy/adwaita".source = "${pkgs.adwaita-fonts}/share/fonts";
      ".local/share/fonts/cozy/fira".source = "${pkgs.fira}/share/fonts";
      ".local/share/fonts/cozy/noto-sans-cjk".source = "${pkgs.noto-fonts-cjk-sans}/share/fonts";
      ".var/app/${app-id}/config/fontconfig".source = ./fontconfig;
    };
    services.flatpak = {
      overrides.${app-id}.Context.filesystems = [
        "/nix/store/:ro"
      ];
      packages = [
        "flathub:app/${app-id}//stable"
      ];
    };
  };
}
