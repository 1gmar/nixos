{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.jellyfin-desktop = {
    enable = lib.mkEnableOption "enable jellyfin-desktop module";
  };
  config =
    let
      workspace = "5: jellyfin";
    in
    lib.mkIf config.jellyfin-desktop.enable {
      assertions = [
        {
          assertion = !config.kodi.enable;
          description = "Can't enable jellyfin-desktop since Kodi is already enabled.";
        }
      ];
      home.packages = [ pkgs.jellyfin-desktop ];
      services.polybar.settings."module/workspaces".icon.text =
        lib.mkIf config.polybar.workspaces.enable
          [
            "${workspace};󰼁"
          ];
      i3.extraConfig = ''
        bindsym Mod4+bracketright workspace ${workspace}
        assign [class="jellyfin-desktop"] ${workspace}
      '';
      xsession.windowManager.i3.config = {
        assigns.${workspace} = [ { class = "jellyfin-desktop"; } ];
        keybindings."Mod4+bracketright" = "workspace ${workspace}";
      };
    };
}
