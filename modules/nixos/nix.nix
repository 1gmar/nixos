{ config, lib, ... }:
{
  options.nix-config = {
    enable = lib.mkEnableOption "enable nix customisations";
  };
  config = lib.mkIf config.nix-config.enable {
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      optimise = {
        automatic = true;
        dates = "monthly";
      };
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
