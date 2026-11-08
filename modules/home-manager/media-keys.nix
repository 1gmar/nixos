{
  config,
  lib,
  pkgs,
  sysConfig,
  ...
}:
let
  playerctl = "${config.home.profileDirectory}/bin/playerctl";
  volume = pkgs.writers.writeNuBin "volume" (builtins.readFile ./nushell/volume-control.nu);
  volumeExe = lib.getExe volume;
in
{
  options.media-keys = {
    enable = lib.mkEnableOption "enable media-keys module";
  };
  config =
    lib.mkIf
      (config.media-keys.enable && config.dunst.enable && (config.i3wm.enable || sysConfig.i3.enable))
      {
        services.playerctld.enable = true;
        i3.extraConfig = ''
          bindsym XF86AudioLowerVolume exec --no-startup-id ${volumeExe} down
          bindsym XF86AudioMute exec --no-startup-id ${volumeExe} mute-toggle
          bindsym XF86AudioRaiseVolume exec --no-startup-id ${volumeExe} up
          bindsym XF86AudioNext exec --no-startup-id ${playerctl} --player=%any next
          bindsym XF86AudioPlay exec --no-startup-id ${playerctl} --player=%any play-pause
          bindsym XF86AudioPrev exec --no-startup-id ${playerctl} --player=%any previous
        '';
        xsession.windowManager.i3.config.keybindings = {
          "XF86AudioLowerVolume" = "exec ${volumeExe} down";
          "XF86AudioMute" = "exec ${volumeExe} mute-toggle";
          "XF86AudioRaiseVolume" = "exec ${volumeExe} up";
          "XF86AudioPlay" = "exec ${playerctl} --player=%any play-pause";
          "XF86AudioNext" = "exec ${playerctl} --player=%any next";
          "XF86AudioPrev" = "exec ${playerctl} --player=%any previous";
        };
      };
}
