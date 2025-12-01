{
  colors,
  config,
  lib,
  pkgs,
  ...
}:
{
  options.weather = {
    enable = lib.mkEnableOption "enable polybar weather module";
  };
  config = lib.mkIf config.weather.enable {
    polybar.rightModules = lib.mkOrder 1040 [ "weather" ];
    services.polybar.settings = {
      "module/weather" = {
        type = "custom/script";
        exec =
          if config.nushell.enable then
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
          fail = "10";
          text = "600";
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
    };
  };
}
