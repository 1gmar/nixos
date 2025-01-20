{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    kitty.enable = lib.mkEnableOption "enable kitty module";
  };
  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      font = {
        package = lib.mkForce (pkgs.nerd-fonts.meslo-lg);
        name = lib.mkForce "MesloLGSNerdFontMono";
      };
    };
  };
}
