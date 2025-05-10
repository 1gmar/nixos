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
      backend = "glx";
      enable = true;
      extraArgs = ["--xrender-sync-fence"];
      vSync = true;
    };
  };
}
