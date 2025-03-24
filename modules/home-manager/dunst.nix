{
  config,
  lib,
  pkgs,
  ...
}: {
  options.dunst = {
    enable = lib.mkEnableOption "enable dunst module";
  };
  config = lib.mkIf config.dunst.enable {
    services.dunst = {
      enable = true;
    };
  };
}
