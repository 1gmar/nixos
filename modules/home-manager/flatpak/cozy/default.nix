{
  config,
  lib,
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
    home.file.".var/app/${app-id}/config/fontconfig/fonts.conf".source = ./fonts.conf;
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
