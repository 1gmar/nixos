{
  colors,
  config,
  lib,
  pkgs,
  ...
}: {
  options.sound-volume = {
    enable = lib.mkEnableOption "enable polybar sound-volume module";
  };
  config = lib.mkIf config.sound-volume.enable {
    polybar.rightModules = lib.mkOrder 1060 ["volume"];
    services.polybar.settings = {
      "module/volume" = {
        type = "internal/pulseaudio";
        click.right = "${pkgs.pavucontrol}/bin/pavucontrol";
        format.volume = "<ramp-volume><label-volume>";
        label.muted = {
          foreground = colors.red;
          text = "%{T2}󰖁%{T-}%percentage:2%%";
        };
        label.volume = "%percentage:2%%";
        ramp.volume = {
          "0".foreground = colors.green;
          "1".foreground = colors.yellow;
          "2".foreground = colors.orange;
          font = "2";
          text = ["󰕿" "󰖀" "󰕾"];
        };
      };
    };
  };
}
