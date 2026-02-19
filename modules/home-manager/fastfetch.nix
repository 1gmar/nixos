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
        modules =
          let
            osKeyColor = "blue";
            wmKeyColor = "yellow";
            pcKeyColor = "green";
            osModules = [
              {
                type = "os";
                key = "OS  ";
              }
              {
                type = "kernel";
                key = " ├  ";
              }
              {
                type = "initsystem";
                key = " ├  ";
              }
              {
                type = "packages";
                key = " ├ 󰏖 ";
              }
              {
                type = "memory";
                key = " ├ 󰓌 ";
              }
              {
                type = "swap";
                key = " ├ 󰓡 ";
              }
              {
                type = "disk";
                format = "{name}, {filesystem} - {size-used} / {size-total} ({size-percentage})";
                key = " ├  ";
              }
              {
                type = "shell";
                key = " └  ";
              }
            ];
            wmModules = [
              {
                type = "wm";
                key = "WM  ";
              }
              {
                type = "wmtheme";
                key = " ├ 󰉼 ";
              }
              {
                type = "lm";
                key = " ├ 󰧨 ";
              }
              {
                type = "de";
                key = " ├  ";
              }
              {
                type = "icons";
                key = " ├ 󰀻 ";
              }
              {
                type = "cursor";
                key = " ├  ";
              }
              {
                type = "terminal";
                key = " ├  ";
              }
              {
                type = "terminalfont";
                key = " └  ";
              }
            ];
            pcModules = [
              {
                type = "host";
                format = "{vendor} {name}";
                key = "PC 󰇅 ";
              }
              {
                type = "bios";
                format = "{type}, {version} ({release})";
                key = " ├ 󰘚 ";
              }
              {
                type = "cpu";
                format = "{name} ({cores-physical}) @ {freq-max}";
                key = " ├  ";
              }
              {
                type = "gpu";
                format = "{vendor} {name} [{type}]";
                key = " ├ 󰢮 ";
              }
              {
                type = "physicalmemory";
                format = "{vendor}, {type}, {size}, {max-speed} MT/s";
                key = " ├  ";
              }
              {
                type = "physicaldisk";
                format = "{name}, {size}, [{physical-type}, {removable-type}]";
                key = " ├ 󰋊 ";
              }
              {
                type = "monitor";
                format = "{name} {width}x{height} in {inch}\", {refresh-rate} Hz";
                key = " └  ";
              }
            ];
            colorF = color: modules: map (m: m // { keyColor = color; }) modules;
          in
          lib.flatten [
            "break"
            (colorF osKeyColor osModules)
            "break"
            (colorF wmKeyColor wmModules)
            "break"
            (colorF pcKeyColor pcModules)
            "break"
          ];
      };
    };
  };
}
