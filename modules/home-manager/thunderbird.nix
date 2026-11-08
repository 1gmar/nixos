{
  lib,
  config,
  pkgs,
  sysConfig,
  ...
}:
{
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
    i3.extraConfig = ''
      assign [class="thunderbird"] ${sysConfig.i3.workspaces.email}
      exec --no-startup-id ${config.home.profileDirectory}/bin/thunderbird
    '';
    xsession.windowManager.i3.config.startup = [
      {
        always = false;
        command = "${pkgs.thunderbird}/bin/thunderbird";
        notification = false;
      }
    ];
  };
}
