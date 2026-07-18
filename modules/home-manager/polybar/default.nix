{
  colors,
  config,
  lib,
  pkgs,
  sysConfig,
  ...
}:
let
  sysCfg = sysConfig.screen-scaling;
in
{
  imports = [
    ./gpu

    ./battery.nix
    ./cpu.nix
    ./datetime.nix
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
    height = lib.mkOption {
      type = str;
      default = "2.0%";
    };
    icon-voffset = lib.mkOption {
      type = ints.between 3 7;
      default = 4;
    };
    text-voffset = lib.mkOption {
      type = ints.between 3 7;
      default = 3;
    };
    centerModules = lib.mkOption {
      type = listOf str;
      default = [ ];
    };
    leftModules = lib.mkOption {
      type = listOf str;
      default = [ ];
    };
    rightModules = lib.mkOption {
      type = listOf str;
      default = [ ];
    };
  };
  config = lib.mkIf config.polybar.enable {
    home.packages = with pkgs; [
      jetbrains-mono
      material-design-icons
    ];
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
        i3Support = true;
        nlSupport = true;
        pulseSupport = true;
      };
      script = "polybar &";
      settings = {
        "bar/i3-bar" = with colors; {
          inherit background;
          foreground = primaryContent;
          border = {
            left.size = "0";
            right.size = "0";
            top.size = "0";
          };
          dpi = lib.mkIf sysCfg.enable {
            x = sysCfg.dpi;
            y = sysCfg.dpi;
          };
          font = [
            "JetBrainsMono:size=12:style=Bold;${toString config.polybar.text-voffset}"
            "Material Design Icons:size=18;${toString config.polybar.icon-voffset}"
            "Fira Sans:size=12:style=Bold;4"
            "Noto Sans CJK JP:size=12:style=Bold;${toString config.polybar.text-voffset}"
            "JetBrainsMono Nerd Font:size=18:style=Bold;${toString config.polybar.icon-voffset}"
          ];
          height = config.polybar.height;
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
    polybar = {
      battery.enable = lib.mkDefault false;
      cpu.enable = lib.mkDefault true;
      datetime.enable = lib.mkDefault true;
      gpu = {
        enable = lib.mkDefault true;
        radeongpu.enable = lib.mkDefault false;
      };
      input-method.enable = lib.mkDefault true;
      memory.enable = lib.mkDefault true;
      network.enable = lib.mkDefault true;
      powermenu.enable = lib.mkDefault true;
      sound-volume.enable = lib.mkDefault true;
      tray.enable = lib.mkDefault true;
      weather.enable = lib.mkDefault true;
      workspaces.enable = lib.mkDefault true;
    };
  };
}
