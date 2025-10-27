{
  config,
  lib,
  ...
}:
{
  options.fastfetch = {
    enable = lib.mkEnableOption "enable fastfetch module";
  };
  config = lib.mkIf config.fastfetch.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          padding = {
            top = 1;
          };
        };
        display = {
          separator = " ➜  ";
        };
        modules = [
          "break"
          {
            type = "os";
            key = "OS  ";
            keyColor = "31";
          }
          {
            type = "kernel";
            key = " ├  ";
            keyColor = "31";
          }
          {
            type = "initsystem";
            key = " ├  ";
            keyColor = "31";
          }
          {
            type = "packages";
            key = " ├ 󰏖 ";
            keyColor = "31";
          }
          {
            type = "memory";
            key = " ├ 󰓌 ";
            keyColor = "31";
          }
          {
            type = "swap";
            key = " ├ 󰓡 ";
            keyColor = "31";
          }
          {
            type = "disk";
            format = "{name}, {filesystem} - {size-used} / {size-total} ({size-percentage})";
            key = " ├  ";
            keyColor = "31";
          }
          {
            type = "shell";
            key = " └  ";
            keyColor = "31";
          }
          "break"
          {
            type = "wm";
            key = "WM  ";
            keyColor = "32";
          }
          {
            type = "wmtheme";
            key = " ├ 󰉼 ";
            keyColor = "32";
          }
          {
            type = "lm";
            key = " ├ 󰧨 ";
            keyColor = "32";
          }
          {
            type = "de";
            key = " ├  ";
            keyColor = "32";
          }
          {
            type = "icons";
            key = " ├ 󰀻 ";
            keyColor = "32";
          }
          {
            type = "cursor";
            key = " ├  ";
            keyColor = "32";
          }
          {
            type = "terminal";
            key = " ├  ";
            keyColor = "32";
          }
          {
            type = "terminalfont";
            key = " └  ";
            keyColor = "32";
          }
          "break"
          {
            type = "host";
            format = "{vendor} {name}";
            key = "PC 󰇅 ";
            keyColor = "33";
          }
          {
            type = "bios";
            format = "{type}, {version} ({release})";
            key = " ├ 󰘚 ";
            keyColor = "33";
          }
          {
            type = "cpu";
            format = "{name} ({cores-physical}) @ {freq-max}";
            key = " ├  ";
            keyColor = "33";
          }
          {
            type = "gpu";
            format = "{vendor} {name} [{type}]";
            key = " ├ 󰢮 ";
            keyColor = "33";
          }
          {
            type = "physicalmemory";
            format = "{vendor}, {type}, {size}, {max-speed} MT/s";
            key = " ├  ";
            keyColor = "33";
          }
          {
            type = "physicaldisk";
            format = "{name}, {size}, [{physical-type}, {removable-type}]";
            key = " ├ 󰋊 ";
            keyColor = "33";
          }
          {
            type = "monitor";
            format = "{name} {width}x{height} in {inch}\", {refresh-rate} Hz";
            key = " └  ";
            keyColor = "33";
          }
          "break"
        ];
      };
    };
  };
}
