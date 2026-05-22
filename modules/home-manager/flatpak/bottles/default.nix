{
  config,
  lib,
  pkgs,
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
    home.file = {
      ".local/share/fonts/bottles/adwaita".source = "${pkgs.adwaita-fonts}/share/fonts";
      ".local/share/fonts/bottles/fira".source = "${pkgs.fira}/share/fonts";
      ".local/share/fonts/bottles/noto-sans-cjk".source = "${pkgs.noto-fonts-cjk-sans}/share/fonts";
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
