{
  colors,
  config,
  lib,
  ...
}: {
  options.workspaces = {
    enable = lib.mkEnableOption "enable polybar workspaces module";
  };
  config = lib.mkIf config.workspaces.enable {
    polybar.leftModules = lib.mkOrder 1050 ["workspaces" "title"];
    services.polybar.settings = {
      "module/title" = {
        type = "internal/xwindow";
        format.prefix = "│";
        label = {
          font = "5";
          foreground = colors.foregroundEmph;
          maxlen = "100";
          text = "%{F${colors.cyan}}%class% %{F${colors.yellow}}∋%{F-} %title%";
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
}
