{
  config,
  lib,
  pkgs,
  ...
}: {
  options.kodi = {
    enable = lib.mkEnableOption "enable kodi module";
  };
  config = lib.mkIf config.kodi.enable {
    home.file.".local/share/applications/kodi.desktop".source = ./kodi.desktop;
    programs.kodi = {
      enable = true;
      package = pkgs.kodi.withPackages (exts: [exts.jellycon]);
      settings = {
        fullscreen = "false";
        seeksteps = "5, 10, 30, 60";
      };
    };
    xsession.windowManager.i3.config = lib.mkIf config.i3wm.enable {
      assigns."5" = [{class = "Kodi";}];
      keybindings."Mod4+bracketright" = "workspace 5";
    };
  };
}
