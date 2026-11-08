{
  config,
  lib,
  pkgs,
  sysConfig,
  ...
}:
let
  change-input-method =
    if config.ibus.enable then "${pkgs.ibus-with-plugins}/bin/ibus engine xkb:us::eng &&" else "";
in
{
  options.screen-locker = {
    enable = lib.mkEnableOption "enable screen-locker module";
  };
  config = lib.mkIf (config.screen-locker.enable && (config.i3wm.enable || sysConfig.i3.enable)) {
    i3.extraConfig = ''
      bindsym Mod4+Escape exec --no-startup-id ${change-input-method} ${pkgs.systemd}/bin/loginctl lock-session && ${pkgs.coreutils-full}/bin/sleep 3 && ${pkgs.xset}/bin/xset dpms force off
    '';
    xsession.windowManager.i3.config.keybindings = {
      "Mod4+Escape" =
        "exec ${change-input-method} ${pkgs.systemd}/bin/loginctl lock-session "
        + "&& ${pkgs.coreutils-full}/bin/sleep 3 "
        + "&& ${pkgs.xset}/bin/xset dpms force off";
    };
  };
}
