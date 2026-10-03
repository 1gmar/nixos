{
  config,
  install-fonts,
  lib,
  ...
}:
let
  app-id = "org.nickvision.money";
in
{
  options.flatpak.denaro = {
    enable = lib.mkEnableOption "enable denaro module";
  };
  config = lib.mkIf config.flatpak.denaro.enable {
    home = {
      packages = [
        (install-fonts {
          pname = "denaro-fonts";
          src = ./fonts.tar.gz;
        })
      ];
      file.".var/app/${app-id}/config/fontconfig/fonts.conf".source = ./fonts.conf;
    };
    services.flatpak = {
      overrides.${app-id}.Context.filesystems = [
        "/nix/store/:ro"
      ];
      packages = [
        "flathub:app/${app-id}//stable:1c3b6465b5fe36c65d7c774f06c2963107aa241f5aa8c499e83d04162dd4798d"
      ];
    };
  };
}
