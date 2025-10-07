{
  colors,
  config,
  lib,
  pkgs,
  ...
}: {
  options.powermenu = {
    enable = lib.mkEnableOption "enable polybar powermenu module";
  };
  config = lib.mkIf config.powermenu.enable {
    polybar.rightModules = lib.mkOrder 1090 ["powermenu"];
    services.polybar.settings = {
      "module/powermenu" = {
        type = "custom/menu";
        expand.right = false;
        label = {
          close = {
            font = "2";
            foreground = colors.violet;
            text = "󰖭";
          };
          open = {
            font = "2";
            foreground = colors.red;
            text = "󰐥";
          };
          separator = {
            text = "|";
          };
        };
        menu = {
          "0" = {
            "0" = {
              exec = "menu-open-1";
              font = "2";
              foreground = colors.yellow;
              text = "󰍃";
            };
            "1" = {
              exec = "menu-open-2";
              font = "2";
              foreground = colors.blue;
              text = "󰜉";
            };
            "2" = {
              exec = "menu-open-3";
              font = "2";
              foreground = colors.red;
              text = "󰐥";
            };
          };
          "1" = {
            "0" = {
              exec = "menu-open-0";
              font = "2";
              text = "󰅁";
            };
            "1" = {
              exec = "${pkgs.i3}/bin/i3-msg exit";
              font = "2";
              foreground = colors.yellow;
              text = "󰍃";
            };
          };
          "2" = {
            "0" = {
              exec = "menu-open-0";
              font = "2";
              text = "󰅁";
            };
            "1" = {
              exec = "${pkgs.systemd}/bin/systemctl reboot";
              font = "2";
              foreground = colors.blue;
              text = "󰜉";
            };
          };
          "3" = {
            "0" = {
              exec = "menu-open-0";
              font = "2";
              text = "󰅁";
            };
            "1" = {
              exec = "${pkgs.systemd}/bin/systemctl poweroff";
              font = "2";
              foreground = colors.red;
              text = "󰐥";
            };
          };
        };
      };
    };
  };
}
