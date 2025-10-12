{
  config,
  lib,
  pkgs,
  ...
}: {
  options.screen-locker = {
    enable = lib.mkEnableOption "enable screen-locker module";
  };
  config = lib.mkIf (config.rofi.enable && config.i3wm.enable) {
    xsession.windowManager.i3.config.keybindings = let
      change-input-method =
        if config.ibus.enable
        then "${pkgs.ibus-with-plugins}/bin/ibus engine xkb:us::eng &&"
        else "";
    in {
      "Mod4+Escape" =
        "exec ${change-input-method} ${pkgs.systemd}/bin/loginctl lock-session "
        + "&& ${pkgs.coreutils-full}/bin/sleep 3 "
        + "&& ${pkgs.xorg.xset}/bin/xset dpms force off";
    };
  };
}
