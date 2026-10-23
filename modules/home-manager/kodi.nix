{
  config,
  lib,
  pkgs,
  ...
}:
let
  workspace = "5: kodi";
in
{
  options.kodi = {
    enable = lib.mkEnableOption "enable kodi module";
  };
  config = lib.mkIf config.kodi.enable {
    assertions = [
      {
        assertion = !config.jellyfin-desktop.enable;
        description = "Can't enable Kodi since jellyfin-desktop is already enabled.";
      }
    ];
    programs.kodi = {
      enable = true;
      package = pkgs.kodi.withPackages (exts: [ exts.jellyfin ]);
      settings = {
        fullscreen = "false";
        seeksteps = "5, 10, 30, 60";
      };
    };
    services.polybar.settings."module/workspaces".icon.text =
      lib.mkIf config.polybar.workspaces.enable
        [
          "${workspace};󰈰"
        ];
    xdg.desktopEntries."kodi" = {
      actions = {
        "Fullscreen" = {
          name = "Open in fullscreen";
          exec = "${config.home.profileDirectory}/bin/kodi -fs";
        };
        "Standalone" = {
          name = "Open in standalone mode";
          exec = "${config.home.profileDirectory}/bin/kodi --standalone";
        };
      };
      categories = [
        "AudioVideo"
        "Video"
        "Player"
        "TV"
      ];
      comment = "Manage and view your media";
      exec = "${config.home.profileDirectory}/bin/kodi --gl-interface=glx";
      genericName = "Media Center";
      icon = "kodi";
      name = "Kodi";
      terminal = false;
      type = "Application";
    };
    xsession.windowManager.i3.config = lib.mkIf config.i3wm.enable {
      assigns.${workspace} = [ { class = "Kodi"; } ];
      keybindings."Mod4+bracketright" = "workspace ${workspace}";
    };
  };
}
