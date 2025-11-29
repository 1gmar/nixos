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
      audioSink = "@DEFAULT_AUDIO_SINK@";
      unmuteCmd = "${pkgs.wireplumber}/bin/wpctl set-mute ${audioSink} 0";
      getVolumeCmd = "${pkgs.wireplumber}/bin/wpctl get-volume ${audioSink} | ${pkgs.gawk}/bin/awk '{if ($3 ~ /MUTED/) print 0; else print 100 * $2}'";
      muteToggleCmd = "${pkgs.wireplumber}/bin/wpctl set-mute ${audioSink} toggle";
      adjustVolumeCmd = sign: "${pkgs.wireplumber}/bin/wpctl set-volume ${audioSink} 5%${sign}";
      sendNotification =
        volume: "${pkgs.dunst}/bin/dunstify -a Volume -h int:value:$(${volume}) -u low blank";
      volumeCmd =
        sign: "exec \"${unmuteCmd} && ${adjustVolumeCmd sign} && ${sendNotification getVolumeCmd}\"";
      muteVolumeCmd = "exec \"${muteToggleCmd} && ${sendNotification getVolumeCmd}\"";
    in
    {
      services.playerctld.enable = true;
      xsession.windowManager.i3.config.keybindings = {
        "XF86AudioLowerVolume" = volumeCmd "-";
        "XF86AudioMute" = muteVolumeCmd;
        "XF86AudioRaiseVolume" = volumeCmd "+";
        "XF86AudioPlay" = "exec ${config.home.profileDirectory}/bin/playerctl --player=%any play-pause";
        "XF86AudioNext" = "exec ${config.home.profileDirectory}/bin/playerctl --player=%any next";
        "XF86AudioPrev" = "exec ${config.home.profileDirectory}/bin/playerctl --player=%any previous";
      };
    }
  );
}
