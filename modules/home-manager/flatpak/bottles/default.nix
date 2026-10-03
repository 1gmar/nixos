{
  config,
  lib,
  ...
}:
let
  app-id = "com.usebottles.bottles";
in
{
  options.flatpak.bottles = {
    enable = lib.mkEnableOption "enable bottles module";
  };
  config = lib.mkIf config.flatpak.bottles.enable {
    home.file.".var/app/${app-id}/config/fontconfig/fonts.conf".source = ./fonts.conf;
    services.flatpak = {
      overrides.${app-id}.Context.filesystems = [
        "/nix/store/:ro"
        "xdg-data/applications:create"
        "xdg-desktop:create"
      ];
      packages = [
        "flathub:app/${app-id}//stable:b63354d6e95377f11796244da517df58866c708aeab2b13cf81082ba5a14c1dd"
      ];
    };
  };
}
