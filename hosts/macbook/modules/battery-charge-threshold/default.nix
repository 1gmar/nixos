{
  config,
  lib,
  ...
}:
{
  options.battery-charge-threshold = {
    enable = lib.mkEnableOption "enable battery charge threshold module";
  };
  config = lib.mkIf config.battery-charge-threshold.enable {
    boot = {
      extraModulePackages = [ (config.boot.kernelPackages.callPackage ./applesmc-next.nix { }) ];
      kernelModules = [
        "sbs"
        "applesmc"
      ];
      extraModprobeConfig = ''
        softdep applesmc pre: sbs
      '';
    };
    systemd.tmpfiles.rules = [
      "w /sys/class/power_supply/BAT0/charge_control_end_threshold - - - - 60"
      "w /sys/class/power_supply/BAT0/charge_control_full_threshold - - - - 58"
    ];
  };
}
