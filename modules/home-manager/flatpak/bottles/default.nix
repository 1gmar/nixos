{
  config,
  lib,
  ...
}:
let
  app-id = "com.usebottles.bottles";
in
{
  options.bottles = {
    enable = lib.mkEnableOption "enable bottles module";
  };
  config = lib.mkIf config.bottles.enable {
    home.file.".var/app/${app-id}/config/fontconfig/fonts.conf".source = ./fonts.conf;
    services.flatpak = {
      overrides.${app-id}.Context.filesystems = [
        "/nix/store/:ro"
      ];
      packages = [
        "flathub:app/${app-id}//stable:bf6246635cdc3ef2986c7cb6a5afc13cb31e30f0784e39ca69da06563855991d"
      ];
    };
  };
}
