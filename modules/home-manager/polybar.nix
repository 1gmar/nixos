{
  colors,
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    polybar.enable = lib.mkEnableOption "enable polybar module";
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
            center = "cpu cpu-fan cpu-temp network gpu gpu-fan gpu-temp";
            left = "workspaces title";
            right = "tray weather memory disk volume input-method date time powermenu";
          };
          padding = "1";
          radius = "1";
          separator = " ";
        };
        "module/cpu" = {
          type = "internal/cpu";
          format = {
            foreground = colors.blue;
            prefix = {
              font = "2";
              text = "󰍛";
            };
            text = "<label>";
            warn = {
              foreground = colors.red;
              prefix = {
                font = "2";
                text = "󰍛";
              };
              text = "<label-warn>";
            };
          };
          interval = "0.5";
          label.text = "%percentage:2%%";
          label.warn = "%percentage:2%%";
          warn.percentage = "90";
        };
        "module/cpu-fan" = {
          type = "custom/script";
          exec =
            if config.nushell.enable
            then
              "${config.home.profileDirectory}/bin/nu -c "
              + "'${pkgs.lm_sensors}/bin/sensors | find fan2 | split row -r `\\s+` | get 1'"
            else
              "${pkgs.lm_sensors}/bin/sensors | ${pkgs.gnugrep}/bin/grep fan2 "
              + "| ${pkgs.gawk}/bin/awk '{print $2}'";
          format = {
            foreground = colors.blue;
            text = "<label>";
          };
          interval = "0.5";
          label = "%output:4%";
        };
        "module/cpu-temp" = {
          type = "custom/script";
          exec =
            if config.nushell.enable
            then
              "${config.home.profileDirectory}/bin/nu -c "
              + "'${pkgs.lm_sensors}/bin/sensors | find `Package id 0:` | split row -r `\\s+` "
              + "| get 3 | str replace -a -r `(\\+|\\.\\d)` ``'"
            else
              "${pkgs.lm_sensors}/bin/sensors | ${pkgs.gnugrep}/bin/grep \"Package id 0:\" "
              + "| ${pkgs.gawk}/bin/awk '{gsub(/(\\+|\\.[0-9])/, \"\", $4); print $4}'";
          format = {
            foreground = colors.blue;
            text = "<label>";
          };
          interval = "0.5";
          label = "%output:4%";
        };
        "module/date" = {
          type = "custom/script";
          exec = "${pkgs.coreutils-full}/bin/date +%a%-e";
          format = {
            foreground = colors.yellow;
            text = "<label>";
          };
          interval = "1";
          label = "%output%";
        };
        "module/time" = {
          type = "custom/script";
          exec = "${pkgs.coreutils-full}/bin/date +%H:%M:%S";
          format = {
            foreground = colors.green;
            text = "<label>";
          };
          interval = "1";
          label = "%output%";
        };
        "module/disk" = {
          type = "internal/fs";
          format = {
            mounted = {
              foreground = colors.violet;
              prefix = {
                font = "2";
                text = "󰋊";
              };
              text = "<label-mounted>";
            };
            warn = {
              foreground = colors.red;
              prefix = {
                font = "2";
                text = "󰋊";
              };
              text = "<label-warn>";
            };
          };
          interval = "10";
          label = {
            mounted = "%percentage_used:2%%";
            warn = "%percentage_used:2%%";
          };
          warn.percentage = "90";
        };
        "module/gpu" = {
          type = "custom/script";
          exec =
            "/run/current-system/sw/bin/nvidia-smi --query-gpu=utilization.gpu "
            + "--format=csv,noheader,nounits";
          format = {
            fail = "<label-fail>";
            foreground = colors.green;
            prefix = {
              font = "2";
              padding.right = "5px";
              text = "󰢮";
            };
            text = "<label>";
          };
          interval = {
            fail = "6000";
            text = "0.5";
          };
          label = {
            fail = {
              font = "2";
              foreground = colors.red;
              text = "󱄋";
            };
            text = "%output:2%%";
          };
        };
        "module/gpu-fan" = {
          type = "custom/script";
          exec =
            if config.nushell.enable
            then
              "${config.home.profileDirectory}/bin/nu -c "
              + "'${pkgs.lm_sensors}/bin/sensors | find fan1 | split row -r `\\s+` | get 1'"
            else
              "(set -o pipefail && ${pkgs.lm_sensors}/bin/sensors "
              + "| ${pkgs.gnugrep}/bin/grep fan1 | ${pkgs.gawk}/bin/awk '{print $2}')";
          format = {
            fail = "<label-fail>";
            foreground = colors.green;
            text = "<label>";
          };
          interval = {
            fail = "6000";
            text = "0.5";
          };
          label = {
            fail = {
              font = "2";
              foreground = colors.red;
              text = "󱄋";
            };
            text = "%output:4%";
          };
        };
        "module/gpu-temp" = {
          type = "custom/script";
          exec =
            "/run/current-system/sw/bin/nvidia-smi --query-gpu=temperature.gpu "
            + "--format=csv,noheader,nounits";
          format = {
            fail = "<label-fail>";
            foreground = colors.green;
            text = "<label>";
          };
          interval = {
            fail = "6000";
            text = "0.5";
          };
          label = {
            fail = {
              font = "2";
              foreground = colors.red;
              text = "󱄋";
            };
            text = "%output:2%°C";
          };
        };
        "module/input-method" = {
          type = "custom/script";
          click.right = "${pkgs.ibus-with-plugins}/bin/ibus-setup";
          exec =
            if config.nushell.enable
            then
              "${config.home.profileDirectory}/bin/nu -c "
              + "'${pkgs.ibus-with-plugins}/bin/ibus engine | if $in =~ `^mozc` { \"ja\" } "
              + "else { $in | split row `:` | get 1 }'"
            else
              "${pkgs.ibus-with-plugins}/bin/ibus engine "
              + "| ${pkgs.gawk}/bin/awk '{if ($1 ~ /^mozc/) print \"ja\"; "
              + "else split($1, L, \":\"); print L[2]}'";
          format = {
            foreground = colors.cyan;
            prefix = {
              font = "2";
              text = "󰥻";
            };
            text = "<label>";
          };
          interval = "1";
          label = "%output:2%";
        };
        "module/memory" = {
          type = "internal/memory";
          format = {
            foreground = colors.violet;
            prefix = {
              font = "2";
              text = "󰘚";
            };
            text = "<label>";
            warn = {
              foreground = colors.red;
              prefix = {
                font = "2";
                text = "󰘚";
              };
              text = "<label-warn>";
            };
          };
          interval = "1";
          label = {
            text = "%percentage_used:2%%";
            warn = "%percentage_used:2%%";
          };
          warn.percentage = "90";
        };
        "module/network" = {
          type = "internal/network";
          format.connected = {
            foreground = colors.yellow;
            text = "<label-connected>";
          };
          format.disconnected = {
            foreground = colors.red;
            text = "<label-disconnected>";
          };
          interface = "enp5s0";
          interval = "0.5";
          label = {
            connected = "%downspeed:10%󰜮%upspeed:10%󰜷";
            disconnected = {
              prefix = {
                font = "2";
                text = "󰲛";
              };
              text = "Disconnected";
            };
          };
        };
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
        "module/title" = {
          type = "internal/xwindow";
          format.prefix = "│";
          label = {
            font = "5";
            foreground = colors.foregroundEmph;
            maxlen = "80";
            text = "%title%";
          };
        };
        "module/tray" = {
          type = "internal/tray";
          format.suffix = "│";
          tray = {
            size = "70%";
            spacing = "2";
          };
        };
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
        "module/weather" = {
          type = "custom/script";
          exec =
            if config.nushell.enable
            then
              "${config.home.profileDirectory}/bin/nu -c "
              + "'${config.home.profileDirectory}/bin/wthrr "
              + "| lines | get 3 | split row `,` | each { split row -r `\\s+` } "
              + "| get 0.1 1.1 | str join `  `'"
            else
              "(set -o pipefail && ${pkgs.wthrr}/bin/wthrr "
              + "| ${pkgs.gawk}/bin/awk 'NR==4 {split($0, L, \",\"); "
              + "split(L[2], S, \" \"); print $2, S[1]}')";
          format = {
            fail = "<label-fail>";
            text = "<label>";
          };
          interval = {
            fail = "5";
            text = "300";
          };
          label = {
            fail = {
              font = "2";
              foreground = colors.red;
              text = "󱯻";
            };
            text = "%output:8%";
          };
        };
        "module/workspaces" = {
          type = "internal/xworkspaces";
          icon = {
            default = "󰘔";
            text = ["1: browser;󰖟" "2: email;󰇰" "3: messenger;󱋊" "4: terminal;󰆍"];
          };
          label = {
            active = {
              background = colors.backgroundHigh;
              foreground = colors.blue;
              padding = 1;
              text = "%icon%";
              underline = colors.secondaryContent;
            };
            occupied = {
              inherit (colors) background;
              foreground = colors.text;
              padding = 1;
              text = "%icon%";
            };
            urgent = {
              inherit (colors) background;
              foreground = colors.red;
              padding = 1;
              text = "%icon%";
            };
          };
        };
      };
    };
  };
}
