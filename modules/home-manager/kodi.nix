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
    home.sessionVariables.KODI_GL_INTERFACE = "GLX";
    programs.kodi = {
      enable = true;
      package = pkgs.kodi.withPackages (exts: [exts.jellycon]);
    };
    xsession.windowManager.i3.config = lib.mkIf config.i3wm.enable {
      assigns."5" = [{class = "Kodi";}];
      keybindings."Mod4+bracketright" = "workspace 5";
    };
  };
}
