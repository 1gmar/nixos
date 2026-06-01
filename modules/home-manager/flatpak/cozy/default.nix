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
      ".local/share/fonts/cozy/noto-sans-cjk".source = "${pkgs.noto-fonts-cjk-sans}/share/fonts";
      ".var/app/${app-id}/config/fontconfig".source = ./fontconfig;
    };
    services.flatpak = {
      overrides.${app-id}.Context.filesystems = [
        "/nix/store/:ro"
      ];
      packages = [
        "flathub:app/${app-id}//stable:32012a4bf819319953699f940e088fd171bb7b03cf60296abd3ef081500d94e4"
      ];
    };
  };
}
