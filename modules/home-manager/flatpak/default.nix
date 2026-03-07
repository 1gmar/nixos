{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.flatpaks.homeModules.default
    ./cozy
    ./denaro
  ];
  options.flatpak = {
    enable = lib.mkEnableOption "enable flatpak module";
  };
  config = lib.mkIf config.flatpak.enable {
    cozy.enable = true;
    denaro.enable = true;

    services.flatpak = {
      enable = true;
      remotes = {
        "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      };
    };
  };
}
