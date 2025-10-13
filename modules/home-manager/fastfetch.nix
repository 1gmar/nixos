{
  config,
  lib,
  ...
}: {
  options.fastfetch = {
    enable = lib.mkEnableOption "enable fastfetch module";
  };
  config = lib.mkIf config.fastfetch.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          padding = {
            top = 2;
          };
        };
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "bios"
          "board"
          "kernel"
          "initsystem"
          "packages"
          "shell"
          "display"
          "lm"
          "de"
          "wm"
          "wmtheme"
          "theme"
          "icons"
          "font"
          "cursor"
          "wallpaper"
          "terminal"
          "terminalfont"
          {
            type = "cpu";
            showPeCoreCount = true;
            temp = true;
          }
          {
            type = "gpu";
            driverSpecific = true;
            temp = true;
          }
          "memory"
          "physicalmemory"
          {
            type = "swap";
            separate = true;
          }
          "disk"
          "btrfs"
          "zpool"
          {
            type = "battery";
            temp = true;
          }
          {
            type = "publicip";
            timeout = 1000;
          }
          {
            type = "localip";
            showIpv6 = true;
            showMac = true;
            showSpeed = true;
            showMtu = true;
            showLoop = true;
            showFlags = true;
            showAllIps = true;
          }
          "dns"
          "locale"
          "vulkan"
          "opengl"
          "opencl"
          {
            type = "physicaldisk";
            temp = true;
          }
          "version"
          "break"
          "colors"
        ];
      };
    };
  };
}
