{
  colors,
  config,
  lib,
  ...
}:
{
  options.workspaces = {
    enable = lib.mkEnableOption "enable polybar workspaces module";
  };
  config = lib.mkIf config.workspaces.enable {
    polybar.leftModules = lib.mkOrder 1050 [
      "workspaces"
      "title"
    ];
    services.polybar.settings = with colors; {
      "module/title" = {
        type = "internal/xwindow";
        format.prefix = "│";
        label = {
          font = "5";
          foreground = highlight;
          maxlen = "100";
          text = "%{F${cyan}}%class% %{F${yellow}}∋%{F-} %title%";
        };
      };
      "module/workspaces" = {
        type = "internal/xworkspaces";
        icon = {
          default = "󰘔";
          text = [
            "1: browser;󰖟"
            "2: email;󰇰"
            "3: messenger;󱋊"
            "4: terminal;󰆍"
          ];
        };
        label = {
          active = {
            background = backHighlight;
            foreground = blue;
            padding = 1;
            text = "%icon%";
            underline = secondaryContent;
          };
          occupied = {
            inherit background;
            foreground = primaryContent;
            padding = 1;
            text = "%icon%";
          };
          urgent = {
            inherit background;
            foreground = red;
            padding = 1;
            text = "%icon%";
          };
        };
      };
    };
  };
}
