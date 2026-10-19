{
  colors,
  lib,
  config,
  pkgs,
  runNuC,
  ...
}:
{
  options.polybar.input-method = {
    enable = lib.mkEnableOption "enable polybar input-method module";
  };
  config = lib.mkIf config.polybar.input-method.enable {
    polybar.rightModules = lib.mkOrder 1070 [ "input-method" ];
    services.polybar.settings = {
      "module/input-method" = {
        type = "custom/script";
        click.right = "${pkgs.ibus-with-plugins}/bin/ibus-setup";
        exec = runNuC [
          "${pkgs.ibus-with-plugins}/bin/ibus engine"
          "| if $in =~ `^mozc` { \"ja\" }"
          "else { $in | split row `:` | get 1 }"
        ];
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
    };
  };
}
