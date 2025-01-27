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
        package = lib.mkForce (pkgs.meslo-lgs-nf);
        name = lib.mkForce "MesloLGS NF";
        size = 14;
      };
      themeFile = "Solarized_Light";
    };
  };
}
