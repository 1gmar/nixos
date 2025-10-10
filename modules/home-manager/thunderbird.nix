{
  lib,
  config,
  pkgs,
  ...
}: {
  options.thunderbird = {
    enable = lib.mkEnableOption "enable thunderbird module";
  };
  config = lib.mkIf config.thunderbird.enable {
    programs.thunderbird = {
      enable = true;
      profiles."igmar" = {
        isDefault = true;
      };
    };
    xsession.windowManager.i3.config.startup = lib.mkIf config.i3wm.enable [
      {
        always = false;
        command = "${pkgs.thunderbird}/bin/thunderbird";
        notification = false;
      }
    ];
  };
}
