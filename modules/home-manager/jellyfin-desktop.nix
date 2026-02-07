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
      home.packages = [ pkgs.jellyfin-desktop ];
      services.polybar.settings."module/workspaces".icon.text = lib.mkIf config.workspaces.enable [
        "${workspace};󰼁"
      ];
      xsession.windowManager.i3.config = lib.mkIf config.i3wm.enable {
        assigns.${workspace} = [ { class = "jellyfin-desktop"; } ];
        keybindings."Mod4+bracketright" = "workspace ${workspace}";
      };
    };
}
