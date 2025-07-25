{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.flatpaks.homeModule
    ./denaro
  ];
  options.flatpak = {
    enable = lib.mkEnableOption "enable flatpak module";
  };
  config = lib.mkIf config.flatpak.enable {
    denaro.enable = true;

    services.flatpak = {
      enable = true;
      remotes = {
        "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      };
    };
  };
}
