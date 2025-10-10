{
  colors,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./cpu.nix
    ./datetime.nix
    ./gpu.nix
    ./input-method.nix
    ./memory.nix
    ./network.nix
    ./powermenu.nix
    ./sound.nix
    ./tray.nix
    ./weather.nix
    ./workspaces.nix
  ];
  options.polybar = with lib.types; {
    enable = lib.mkEnableOption "enable polybar module";
    centerModules = lib.mkOption {
      type = listOf str;
      default = [];
    };
    leftModules = lib.mkOption {
      type = listOf str;
      default = [];
    };
    rightModules = lib.mkOption {
      type = listOf str;
      default = [];
    };
  };
  config = lib.mkIf config.polybar.enable {
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
        i3Support = true;
        nlSupport = true;
        pulseSupport = true;
      };
      script = "polybar &";
      settings = {
        "bar/i3-bar" = {
          inherit (colors) background;
          foreground = colors.text;
          border = {
            left.size = "0";
            right.size = "0";
            top.size = "0";
          };
          font = [
            "JetBrainsMono:size=12:style=Bold;3"
            "Material Design Icons:size=18;4"
            "Noto Sans CJK JP:size=12:style=Bold;3"
            "JetBrainsMono Nerd Font:size=18:style=Bold;4"
            "Fira Sans:size=12:style=Bold;4"
          ];
          height = "2.0%";
          line.size = "2";
          module.margin = "0";
          modules = {
            center = lib.concatStringsSep " " config.polybar.centerModules;
            left = lib.concatStringsSep " " config.polybar.leftModules;
            right = lib.concatStringsSep " " config.polybar.rightModules;
          };
          padding = "1";
          radius = "1";
          separator = " ";
        };
      };
    };
    xsession.windowManager.i3.config.startup = lib.mkIf config.i3wm.enable [
      {
        always = true;
        command = "systemctl --user restart polybar.service";
        notification = false;
      }
    ];
    cpu.enable = true;
    datetime.enable = true;
    gpu.enable = true;
    input-method.enable = true;
    memory.enable = true;
    network.enable = true;
    powermenu.enable = true;
    sound-volume.enable = true;
    tray.enable = true;
    weather.enable = true;
    workspaces.enable = true;
  };
}
