{
  lib,
  config,
  ...
}: {
  options.picom = {
    enable = lib.mkEnableOption "enable picom module";
  };
  config = lib.mkIf config.picom.enable {
    services.picom = {
      enable = true;
      vSync = true;
    };
  };
}
