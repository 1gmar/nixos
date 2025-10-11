{
  config,
  lib,
  pkgs,
  ...
}: {
  options.ibus = {
    enable = lib.mkEnableOption "enable ibus module";
  };
  config = lib.mkIf config.ibus.enable {
    environment.variables.GLFW_IM_MODULE = "ibus";
    i18n.inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [mozc];
    };
  };
}
