{
  config,
  lib,
  pkgs,
  ...
}:
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
      package = pkgs.kodi.withPackages (exts: [ exts.jellycon ]);
      settings = {
        fullscreen = "false";
        seeksteps = "5, 10, 30, 60";
      };
    };
    xdg.desktopEntries."Kodi" = {
      actions = {
        "Fullscreen" = {
          name = "Open in fullscreen";
          exec = "${config.profileDirectory}/bin/kodi -fs";
        };
        "Standalone" = {
          name = "Open in standalone mode";
          exec = "${config.profileDirectory}/bin/kodi --standalone";
        };
      };
      categories = [
        "AudioVideo"
        "Video"
        "Player"
        "TV"
      ];
      comment = "Manage and view your media";
      exec = "${config.profileDirectory}/bin/kodi --gl-interface=glx";
      genericName = "Media Center";
      icon = "kodi";
      terminal = false;
      type = "Application";
    };
    xsession.windowManager.i3.config = lib.mkIf config.i3wm.enable {
      assigns."5" = [ { class = "Kodi"; } ];
      keybindings."Mod4+bracketright" = "workspace 5";
    };
  };
}
