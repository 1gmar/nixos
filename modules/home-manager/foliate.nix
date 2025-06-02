{
  lib,
  config,
  ...
}: {
  options.foliate = {
    enable = lib.mkEnableOption "enable foliate module";
  };
  config = lib.mkIf config.foliate.enable {
    dconf.settings = with lib.hm.gvariant; {
      "com/github/johnfactotum/Foliate/viewer/font" = {
        default-size = mkUint32 18;
        sans-serif = "Fira Sans 10";
        serif = "Noto Serif 10";
      };
      "com/github/johnfactotum/Foliate/viewer/view" = {
        override-font = true;
        theme = "solarized";
      };
    };
    programs.foliate.enable = true;
  };
}
