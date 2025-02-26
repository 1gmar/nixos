{
  lib,
  config,
  ...
}: {
  options = {
    kitty.enable = lib.mkEnableOption "enable kitty module";
  };
  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = lib.mkForce "MesloLGS NF";
        size = lib.mkForce 14;
      };
      themeFile = "Solarized_Light";
    };
  };
}
