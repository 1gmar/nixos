{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.media-keys = {
    enable = lib.mkEnableOption "enable media-keys module";
  };
  config = lib.mkIf (config.media-keys.enable && config.dunst.enable && config.i3wm.enable) (
    let
      playerctl = "${config.home.profileDirectory}/bin/playerctl";
      volume = pkgs.writers.writeNuBin "volume" (builtins.readFile ./nushell/volume-control.nu);
      volumeExe = lib.getExe volume;
    in
    {
      services.playerctld.enable = true;
      xsession.windowManager.i3.config.keybindings = {
        "XF86AudioLowerVolume" = "exec ${volumeExe} down";
        "XF86AudioMute" = "exec ${volumeExe} mute-toggle";
        "XF86AudioRaiseVolume" = "exec ${volumeExe} up";
        "XF86AudioPlay" = "exec ${playerctl} --player=%any play-pause";
        "XF86AudioNext" = "exec ${playerctl} --player=%any next";
        "XF86AudioPrev" = "exec ${playerctl} --player=%any previous";
      };
    }
  );
}
