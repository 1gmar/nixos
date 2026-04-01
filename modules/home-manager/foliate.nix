{
  lib,
  config,
  ...
}:
{
  options.foliate = {
    enable = lib.mkEnableOption "enable foliate module";
  };
  config = lib.mkIf config.foliate.enable {
    dconf.settings = with lib.hm.gvariant; {
      "com/github/johnfactotum/Foliate/viewer/font" = {
        default-size = mkUint32 26;
        sans-serif = "Fira Sans 10";
        serif = "Noto Serif 10";
      };
      "com/github/johnfactotum/Foliate/viewer/view" = {
        autohide-cursor = true;
        override-font = false;
        max-block-size = mkUint32 1180;
        max-inline-size = mkUint32 1080;
        theme = "default";
      };
    };
    programs.foliate.enable = true;
  };
}
