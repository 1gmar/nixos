{
  colors,
  lib,
  config,
  pkgs,
  ...
}: {
  options.input-method = {
    enable = lib.mkEnableOption "enable polybar input-method module";
  };
  config = lib.mkIf config.input-method.enable {
    polybar.rightModules = lib.mkOrder 1070 ["input-method"];
    services.polybar.settings = {
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
    };
  };
}
