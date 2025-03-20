{
  config,
  lib,
  ...
}: {
  options.dconf-settings = {
    enable = lib.mkEnableOption "enable dconf settings module";
  };
  config = lib.mkIf config.dconf-settings.enable {
    dconf.settings = {
      "desktop/ibus/general" = {
        engines-order = ["xkb:us::eng" "xkb:ro:std:ron" "xkb:ru:phonetic_YAZHERTY:rus" "mozc-on"];
        preload-engines = ["mozc-on" "xkb:us::eng" "xkb:ru:phonetic_YAZHERTY:rus" "xkb:ro:std:ron"];
        use-system-keyboard-layout = false;
      };
      "desktop/ibus/general/hotkey" = {
        triggers = ["<Super>space"];
      };
      "desktop/ibus/panel" = {
        show-icon-on-systray = false;
      };
      "desktop/ibus/panel/emoji" = {
        font = "Noto Sans 16";
        hotkey = ["<Super>period"];
        unicode-hotkey = ["<Control><Shift>u"];
      };
    };
  };
}
